/* BattleShip
 * Author: ASUS
 * Creation date: 12/5/2024
 */

MACHINE 
   BattleShip

SETS
  PLAYER = {player1, player2};
  GAME_STATE = {ongoing, player1_wins, player2_wins, deploy_required , player1_deploying, player2_deploying};
  REPORT = {success, invalidPositions, hit, player1Wins, player2Wins, miss,player1AlreadyDeployed,player2NotReady};
  ROW = {row1, row2, row3, row4, row5, row6, row7, row8, row9, row10};
  COLUMN = {col1, col2, col3, col4, col5, col6, col7, col8, col9, col10}

CONSTANTS
    GRID,
  SHIP_COUNT

PROPERTIES
    GRID = ROW * COLUMN &
  SHIP_COUNT = 3

VARIABLES
  player1_ships,
  player2_ships,
  player1_shots,
  player2_shots,
  current_player,
  game_status,
  selected_row,
  selected_column

INVARIANT
  player1_ships <: ROW * COLUMN &
  player2_ships <: ROW * COLUMN &
  card(player1_ships) <= SHIP_COUNT &
  card(player2_ships) <= SHIP_COUNT &
  player1_shots : NAT &
  player2_shots : NAT &
  current_player : PLAYER &
  game_status : GAME_STATE &
  selected_row : ROW &
  selected_column : COLUMN

INITIALISATION
    player1_ships, player2_ships := {}, {} ||
    player1_shots, player2_shots := 0, 0 ||
    current_player := player1 ||
    game_status := deploy_required ||
    selected_row := row1 || 
    selected_column := col1

OPERATIONS

    Select_Row(row_val) =
        PRE
            row_val : ROW
        THEN
            selected_row := row_val
        END;

    Select_Column(col_val) =
        PRE
            col_val : COLUMN
        THEN
            selected_column := col_val
        END;
        
report <-- deployFleet(player, row, col) =
  PRE
    player : PLAYER &
    row : ROW &
    col : COLUMN &
    selected_row = row &
    selected_column = col &
    row |-> col /: player1_ships & 
    row |-> col /: player2_ships &
    (game_status = deploy_required or game_status = player1_deploying or game_status = player2_deploying) &
    report : REPORT
  THEN
    IF (player = player1) THEN
      IF (card(player1_ships) < 3) THEN
        player1_ships := player1_ships \/ {row |-> col} ||
        report := success ||
        IF (card(player1_ships) = 2) THEN //Warning
          game_status := player2_deploying
        END
      ELSE
        report := player1AlreadyDeployed
      END
    ELSE
      IF (game_status = player2_deploying) THEN
        player2_ships := player2_ships \/ {row |-> col} ||
        report := success ||
        IF (card(player2_ships) = 2) THEN
          game_status := ongoing ||
          current_player := player1
          
        END
      ELSE
        report := player2NotReady
      END
    END
  END;


report <-- playerShoots(row, col) =
  PRE
    row : ROW &
    col : COLUMN &
    game_status = ongoing &
    report : REPORT &
    selected_row = row &
    selected_column = col
  THEN
    IF (player1_ships = {}) THEN
        game_status := player2_wins || report := player2Wins
    ELSIF (player2_ships = {}) THEN
        game_status := player1_wins ||report := player1Wins
    ELSE
        IF (current_player = player1) THEN
      player1_shots := player1_shots + 1 ||
      IF (row |-> col) : player2_ships THEN
        player2_ships := player2_ships - {row |-> col} ||
//        IF (player1_ships = {}) THEN
//          game_status := player2_wins ||
//          report := player2Wins
//        ELSE
          report := hit
//        END
      ELSE
        report := miss
      END ||
      current_player := player2
    ELSE
      player2_shots := player2_shots + 1 ||
      IF (row |-> col) : player1_ships THEN
        player1_ships := player1_ships - {row |-> col} ||
        IF (player1_ships = {}) THEN
          game_status := player2_wins ||
          report := player2Wins
        ELSE
          report := hit
        END
      ELSE
        report := miss
      END ||
      current_player := player1
    END
    END
    // Check if the game has ended (all ships hit for one player)
//    IF (player1_ships = {}) THEN
//      game_status := player2_wins ||
//      report := player2Wins
//    ELSE IF (player2_ships = {}) THEN
//      game_status := player1_wins ||
//      report := player1Wins
//    END
//  END
  END;



shipsquares <-- shipLocations(player) =
  PRE
    player : PLAYER
  THEN
    CASE player OF EITHER
      player1 THEN shipsquares := player1_ships
      OR
      player2 THEN shipsquares := player2_ships
    END
  END
  END;

shipCounts <-- shipsLeft =
  BEGIN
    shipCounts := (SHIP_COUNT - card(player1_ships), SHIP_COUNT - card(player2_ships))
  END;

shotCount <-- shotsTaken(player) =
  PRE
    player : PLAYER
  THEN
    CASE player OF EITHER
      player1 THEN shotCount := player1_shots || 
          IF player1_shots = 3 THEN
          game_status := player1_wins
          END
      OR
      player2 THEN shotCount := player2_shots || 
          IF player1_shots = 3 THEN
          game_status := player2_wins
          END
    END
  END
  END;

report <-- gameStatus =
BEGIN
    report := game_status
//  PRE
//    report : REPORT
//  THEN
//    CASE game_status OF EITHER
//      player1_wins THEN report := player1Wins
//      OR
//      player2_wins THEN report := player2Wins
//    END
//  END
  END

END


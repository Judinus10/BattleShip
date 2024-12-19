/* BATTLE_SHIP 
* Author: ASUS 
* Date: 11/1/2024 
*/ 
MACHINE 
BATTLE_SHIP 
SETS 
PLAYER = {player1, player2}; /* Represents the two players in 
the game */ 
GAME_STATE = {ongoing, player1_wins, player2_wins, 
deploy_required, player1_deploying, player2_deploying}; /* 
State of the game */ 
REPORT = {success, invalidPositions, hit, player1Wins, 
player2Wins, miss, player1AlreadyDeployed, player2NotReady}; 
ROW = {row1, row2, row3, row4, row5, row6, row7, row8, row9, 
row10}; /* Grid rows */ 
COLUMN = {col1, col2, col3, col4, col5, col6, col7, col8, col9, 
col10} /* Grid columns */ 
CONSTANTS 
GRID, /* Represents the full 10x10 grid */ 
SHIP_COUNT /* The total number of ships allowed per player */ 
PROPERTIES 
GRID = ROW * COLUMN & /* A Cartesian product representing all 
possible positions on the grid */ 
SHIP_COUNT = 3 /* Each player can deploy exactly 3 ships */ 
VARIABLES 
player1_ships, /* Stores positions of player1's ships */ 
player2_ships, /* Stores positions of player2's ships */ 
player1_shots, /* Number of shots fired by player1 */ 
player2_shots, /* Number of shots fired by player2 */ 
current_player, /* Tracks which player’s turn it is */ 
game_status, /* Tracks the current state of the game */ 
selected_row, /* Temporary variable to store the selected row 
*/ 
selected_column /* Temporary variable to store the selected 
column */ 
INVARIANT 
player1_ships <: ROW * COLUMN & /* Player1's ships are a subset 
of the grid */ 
player2_ships <: ROW * COLUMN & /* Player2's ships are a subset 
of the grid */ 
card(player1_ships) <= SHIP_COUNT & /* Player1 cannot deploy 
more than 3 ships */ 
card(player2_ships) <= SHIP_COUNT & /* Player2 cannot deploy 
more than 3 ships */ 
player1_shots : NAT & /* Shots taken by player1 are non
negative */ 
player2_shots : NAT & /* Shots taken by player2 are non
negative */ 
current_player : PLAYER & /* Ensures the current player is 
either player1 or player2 */ 
game_status : GAME_STATE & /* Game state must be valid */ 
selected_row : ROW & /* The selected row is valid */ 
selected_column : COLUMN /* The selected column is valid */ 
INITIALISATION 
/* Initialize game variables to starting values */ 
player1_ships, player2_ships := {}, {} || /* Empty ship 
positions for both players */ 
player1_shots, player2_shots := 0, 0 || /* Reset shot counts to 
0 */ 
current_player := player1 || /* Player1 begins the game */ 
game_status := player1_deploying || /* Game starts in 
deployment phase */ 
selected_row := row1 || /* Default selected row */ 
selected_column := col1 /* Default selected column */ 
OPERATIONS 
/* Allows a player to select a row */ 
Select_Row(row_val) = 
PRE 
row_val : ROW /* Row must be valid */ 
THEN 
selected_row := row_val 
END; 
/* Allows a player to select a column */ 
Select_Column(col_val) = 
PRE 
col_val : COLUMN /* Column must be valid */ 
THEN 
selected_column := col_val 
END; 
/* * Operation to deploy ships at a selected location */ 
report <-- deployFleet(player,position) = 
PRE 
player : PLAYER & /* Must specify a valid player */ 
position : ROW * COLUMN & /* Position is a pair (row, column) 
*/ 
selected_row |-> selected_column = position & /* Ensure 
selected position matches */ 
position /: player1_ships & /* Prevent duplicate positions for 
player1 */ 
position /: player2_ships & /* Prevent duplicate positions for 
player2 */ 
report : REPORT & /* Report must be a valid value */  
game_status /= ongoing  
THEN 
IF (player = player1) THEN 
IF ( game_status = player1_deploying) THEN 
IF (card(player1_ships) < 3) THEN /* Check if player1 has 
deployed fewer than 3 ships */ 
player1_ships := player1_ships \/ {position} || report := 
success ; 
IF (card(player1_ships) = 3) THEN 
game_status := player2_deploying || current_player := player2 
END 
END 
ELSE 
report := player1AlreadyDeployed 
END 
ELSE 
IF (game_status = player2_deploying) THEN 
IF (card(player2_ships) < 3) THEN /* Check if player2 has 
deployed fewer than 3 ships */ 
player2_ships := player2_ships \/ {position} || report := 
success; 
IF (card(player2_ships) = 3) THEN 
game_status := ongoing || current_player := player1  
END 
END 
ELSE 
report := player2NotReady 
END 
END 
END;  
/* Operation for a player to fire a shot at a given location */ 
report <-- playerShoots(target) = 
PRE 
target : ROW * COLUMN & /* Target must be a valid row-column 
pair */ 
game_status = ongoing & /* Game must be in progress */ 
report : REPORT & /* Report must be a valid value */ 
selected_row |-> selected_column = target /* Ensure selected 
target matches */ 
THEN 
IF (current_player = player1) THEN 
player1_shots := player1_shots + 1 || 
IF (target) : player2_ships THEN /* Check if shot hits 
player2's ship */ 
player2_ships := player2_ships - {target} ; 
IF (player2_ships = {}) THEN 
game_status := player1_wins || report := player1Wins 
ELSE 
report := hit || current_player := player2 
END 
ELSE 
report := miss || current_player := player2   
END 
ELSE 
player2_shots := player2_shots + 1 || 
IF (target) : player1_ships THEN /* Check if shot hits 
player1's ship */ 
player1_ships := player1_ships - {target} ; 
IF (player1_ships = {}) THEN 
game_status := player2_wins || report := player2Wins 
ELSE 
report := hit || current_player := player1 
END 
ELSE 
report := miss || current_player := player1 
END  
END 
END; 
/* Returns the ship positions of a player */ 
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
/* Operation to output the number of ships left for both 
players */ 
player1Count, player2Count <-- shipsLeft = 
BEGIN 
player1Count := card(player1_ships) || 
player2Count := card(player2_ships) 
END; 
/* Returns the number of shots taken by a player */ 
shotCount <-- shotsTaken(player) = 
PRE 
player : PLAYER 
THEN 
CASE player OF EITHER 
player1 THEN shotCount := player1_shots  
OR 
player2 THEN shotCount := player2_shots  
END 
END 
END; 
/* Returns the current game status */ 
report <-- gameStatus = 
BEGIN 
report := game_status 
END 
END 

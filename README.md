---

# BATTLE_SHIP
---

## Table of Contents

1. [Project Overview](#project-overview)  
2. [Description](#description)  
3. [Game States](#game-states)  
4. [Sets and Constants](#sets-and-constants)  
5. [Variables and Invariants](#variables-and-invariants)  
6. [Operations](#operations)  
7. [Dependencies](#dependencies)  
8. [How to Run](#how-to-run)  

---

## Project Overview  

This **BATTLE_SHIP** project is a formal specification of a simplified **Battleship game** written in **B-Method**. It uses the abstract machine notation (AMN) and provides operations for players to deploy ships, fire shots, and query the game status.  

The project is designed to demonstrate modeling of game logic, state management, and constraints using Atelier B or ProB tools.

---

## Description  

The game involves:  
- A **10x10 grid** where players can deploy ships.  
- **Two players** (`player1` and `player2`), each with 3 ships to place on the grid.  
- Alternating turns for players to fire shots at the opponent’s grid positions.  
- The first player to **sink all of their opponent's ships wins**.  

The game progresses through the following phases:  
1. Deployment phase: Players place ships.  
2. Gameplay phase: Players take turns shooting at positions.  
3. Winning phase: A winner is declared when one player has no ships left.  

---

## Game States  

The game is governed by the following states:  

| State               | Description                                    |  
|---------------------|------------------------------------------------|  
| `deploy_required`   | Deployment phase, awaiting player actions.     |  
| `player1_deploying` | Player1 is placing ships.                      |  
| `player2_deploying` | Player2 is placing ships.                      |  
| `ongoing`           | Game is in progress, players are firing shots. |  
| `player1_wins`      | Player1 wins the game.                         |  
| `player2_wins`      | Player2 wins the game.                         |  

---

## Sets and Constants  

### Sets  
- `PLAYER`: `{player1, player2}`  
- `GAME_STATE`: `{ongoing, player1_wins, player2_wins, deploy_required, player1_deploying, player2_deploying}`  
- `REPORT`: `{success, invalidPositions, hit, player1Wins, player2Wins, miss, player1AlreadyDeployed, player2NotReady}`  
- `ROW`: `{row1, row2, ..., row10}`  
- `COLUMN`: `{col1, col2, ..., col10}`  

### Constants  
- `GRID`: The Cartesian product of `ROW` and `COLUMN` (10x10 grid).  
- `SHIP_COUNT`: The total number of ships allowed per player (3).  

---

## Variables and Invariants  

### Variables  
- `player1_ships`, `player2_ships`: Positions of each player’s ships.  
- `player1_shots`, `player2_shots`: Number of shots taken by each player.  
- `current_player`: Tracks whose turn it is (`player1` or `player2`).  
- `game_status`: The current game state.  
- `selected_row`, `selected_column`: Temporary variables for row/column selection.  

### Invariants  
- Ship positions must be subsets of the grid.  
- Players cannot deploy more than 3 ships.  
- Shot counts are non-negative.  
- Current player and game state are valid at all times.  

---

## Operations  

### Deployment Phase  

1. **`Select_Row(row_val)`**  
   - Allows a player to select a row.  
   - Precondition: `row_val` must be a valid `ROW`.  

2. **`Select_Column(col_val)`**  
   - Allows a player to select a column.  
   - Precondition: `col_val` must be a valid `COLUMN`.  

3. **`deployFleet(player, position)`**  
   - Deploys a ship for a player at a specified position.  
   - Precondition: The position must be valid and not already occupied.  

---

### Gameplay Phase  

4. **`playerShoots(target)`**  
   - Allows a player to fire a shot at a target grid position.  
   - Reports a hit, miss, or win status.  
   - Precondition: Game state must be `ongoing`.  

---

### Query Operations  

5. **`shipLocations(player)`**  
   - Returns the ship positions of a player.  

6. **`shipsLeft`**  
   - Returns the number of ships left for both players.  

7. **`shotsTaken(player)`**  
   - Returns the number of shots fired by a player.  

8. **`gameStatus`**  
   - Returns the current game status.  

---

## Dependencies  

This project is developed for use with:  
- **Atelier B** or **ProB** tools to verify, animate, and validate the machine.

---

## How to Run  

1. Install **Atelier B** or **ProB**.  
2. Load the **BATTLE_SHIP.mch** file into the tool.  
3. Animate the operations step-by-step:  
   - Begin with `INITIALISATION`.  
   - Use `Select_Row` and `Select_Column` to choose ship deployment positions.  
   - Use `deployFleet` to place ships.  
   - Use `playerShoots` to fire at the opponent’s positions.  
   - Query game status and remaining ships using `gameStatus` and `shipsLeft`.  

4. Verify invariants and constraints using the tool.  

---

## Notes  

- Players can only fire shots when the game status is `ongoing`.  
- Ship positions must be unique and cannot exceed 3 per player.  
- Default starting player is `player1`.  

---

## Future Improvements  

- Add support for random ship deployment.  
- Enhance with additional validation or user inputs.  

---  

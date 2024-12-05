# CuceiTacoTycoon
 Taco-Seller Tycoon Type Game

 Cucei Taco Tycoon is a business simulation game made in Godot Engine inspired by Lemonade Tycoon Deluxe, where players take on the role of a university student who, after leaving home, starts a taco stand to make a living. With limited starting funds, players must make strategic choices in purchasing ingredients, planning recipes, and setting up their stand to cater to various customer preferences.

As players progress, they unlock upgrades and bonuses like extra tips, faster customer visits, and increased reputation. By completing missions, players expand their business reach and compete to become the top taco vendor on campus, gaining the respect and loyalty of their customers through strategic decisions and effective management.

Gameplay Preview

The UI of Cucei Taco Tycoon is crafted for clarity and accessibility, allowing players to quickly navigate the game without confusion. Inspired by the dual-screen mechanics of Nintendo DS games, the HUD places every critical gameplay element within reach, giving players the ability to manage inventory, track customer satisfaction, and control daily operations all from one screen.

![CuceiTacoTycoon](https://github.com/user-attachments/assets/3c9ebfdf-43ad-4d41-ae74-f3a79abbb612)

Class Diagram

![Diagrama_Clases](https://github.com/user-attachments/assets/0d79b709-cad0-400b-b2ee-f36b95ce592e)


Overview of Class Diagram
The diagram represents the architecture and behavior of the scripts used to manage game features such as resource management, player interaction, and character behavior. Below is a breakdown:

1. Spawner.gd: 
Handles character spawning logic, determining intervals, probabilities, and managing instances of characters.

2. SuppliesUI.gd: 
Manages the interface for supplies, including updating labels for tortillas, meat, vegetables, salsa, and the total inventory. It also calculates the total cost for resources purchased or sold.

3. Inventory.gd: 
Tracks the player's inventory, including quantities of tortillas, meat, vegetables, salsa, and their categories (normal, medium, large). It also calculates costs and manages player money for buying and selling supplies.

4. PathFollow2D.gd: 
Controls the movement of characters, including animations, starting and stopping movement, and handling interactions (e.g., buying animations at the lemonade cart). It also integrates collision detection.

5. ButtonDisplay.gd: 
Manages panel displays triggered by buttons. It provides methods for showing and hiding panels and linking button presses to specific actions.

6. Panel5Buttons.gd: 
Groups button behaviors related to the supplies management system. Includes actions for showing/hiding panels and buttons specific to resources like tortillas, meat, salsa, and vegetables.

7. TextureButtons.gd: 
Handles button functionality for purchasing and selling resources in different sizes (small, medium, large). This script connects button presses to inventory adjustments and updates the UI.

8. LemonadeCarCollision.gd: 
Handles events and logic for character interaction with a lemonade cart collision area.

9. StartButton.gd: 
Controls the functionality of the game’s start button, initializing processes when the game begins.

Animations

![Animations](https://github.com/user-attachments/assets/d1c1ef28-eb29-4541-9337-75dd0afdf219)

In CuceiTacoTycoon, animations are primarily managed through the PathFollow2D.gd script and involve dynamic character movement and interaction:

Character Animations:
Characters use an AnimatedSprite or similar nodes to play specific animations (e.g., walking, buying, fading out). The PathFollow2D.gd script ensures smooth movement along predefined paths and triggers animations based on events like starting to move, reaching a target, or interacting with objects.

Key moments, such as interacting with the taco stand or reaching the map's edge, initiate animations dynamically. The system ensures smooth transitions, such as pausing for a buying animation and resuming movement afterward, creating fluid and engaging character behavior.

extends CanvasLayer

const SLIDES := [
	{
		"id": "controls",
		"image": preload("res://tutorial_images/game_screen.png"),
		"text": "alirght listen up \nA / D or Left / Right to move the aim line. \n hold enter to charge you shot \n (extra: hit space and use W / S or Up / Down for more options)",
		"show_arrow": false,
		"show_points": false,
	},
	{
		"id": "round_goal",
		"image": preload("res://tutorial_images/round_goal_screen.png"),
		"text": "every round has a goal. \n hit it, or its over. \n its that simple",
		"show_arrow": true,
		"show_points": false,
	},
	{
		"id": "points",
		"image": null,
		"text": "some holes are more equal than other holes",
		"show_arrow": false,
		"show_points": true,
	},
	{
		"id": "shop",
		"image": preload("res://tutorial_images/shop_screen.png"),
		"text": "every 5 rounds a shop opens \n powerups can help, mostly \n rerolls cost 50 \n choose wisely",
		"show_arrow": false,
		"show_points": false,
	},
]

---
title: games
has_children: false
nav_order: 1
permalink: /games/
---

# games

<div class="games-gallery">
	{% for entry in site.data.games %}
	{% assign game = entry[1] %}
	<a href="{{ '/games/' | append: entry[0] | append: '/' | relative_url }}">
		<img src="{{ '/assets/games/' | append: entry[0] | append: '.png' | relative_url }}" alt="">
		<span>{{ game.title | escape }}</span>
	</a>
	{% endfor %}
</div>

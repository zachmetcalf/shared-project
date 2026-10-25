---
title: games
has_children: false
nav_order: 1
permalink: /games/
---

# games

<div class="games-gallery">
	{% for entry in site.data.games %}
	{% assign slug = entry[0] %}
	<a href="{{ '/games/' | append: slug | append: '/' | relative_url }}">
		<h2>{{ slug | escape }}</h2>
		<img src="{{ '/assets/games/' | append: slug | append: '.png' | relative_url }}" alt="">
	</a>
	{% endfor %}
</div>

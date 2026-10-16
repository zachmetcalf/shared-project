---
title: games
has_children: false
nav_order: 1
permalink: /games/
---

# games

{% for entry in site.data.games %}
{% assign game = entry[1] %}
- [{{ game.title }}]({{ '/games/' | append: entry[0] | append: '/' | relative_url }})
{% endfor %}

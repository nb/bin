// ==UserScript==
// @name         Visit URL button for TeuxDeux
// @description  If an item is a URL, adds a button to visit it
// @include      http://teuxdeux.com/*
// @author       Nikolay Bachiyski
// ==/UserScript==

(function () {
	var increase_css_property = function(el, property, increment) {
		if (!el.length) return;
		var old = el.css(property).replace('px', '');
		el.css(property, (parseInt(old) + increment) + 'px');
	};
	
	var add_visit_links = function(teuxdeux_paragraphs) {
		teuxdeux_paragraphs.each(function() {
			var $p = $(this);
			var $item = $p.parents('li');
			var $wrap = $('.wrap', $item);
			var $task = $('.task', $item);
			var is_link = $p.text().match(/^https?:\/\//);
			var has_link_button = $('a.visit', $wrap).length;
			if ( is_link ) {
				if ( has_link_button ) return;
				$wrap.prepend('<a title="Visit the link &rarr;" class="visit" href="'+$p.text()+'" style="display: inline; position: static; color: #eee; font-weight: bold; text-decoration: none; background-color: #888; padding: 2px; visibility: visible;">&rarr;</a>');
				var $a = $('a.visit', $wrap);
				var offset = $a.width() * 1.5;
				increase_css_property($task, 'padding-right', offset);
				increase_css_property($p, 'margin-right', offset);
				increase_css_property($wrap, 'width', offset);
				$a.click(function() {
					window.location = $a.attr('href');
				});
			} else {
				if ( has_link_button ) {
					$('a.visit', $wrap).remove();
				}
			}
		});
	};

	add_visit_links($('p.teuxdeux'));

	$('ul.list_items').bind('DOMNodeInserted', function() {
		add_visit_links($('p.teuxdeux', $(this)));
	});
})();
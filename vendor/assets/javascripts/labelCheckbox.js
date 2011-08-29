(function($){

//--------------------------------------------------------------------
//  LABEL CHECKBOX
//--------------------------------------------------------------------

$.fn.labelCheckbox = function()
{

//----------------------------------
//  main loop
//----------------------------------

// return this for jQuery chainability
return this.each(function()
{

	//----------------------------------
	//  init
	//----------------------------------

	// get the jQuery of this
	var $this = $(this)
		.addClass('checkbox')
		// add event listener
		.bind('click', clickHandler)
		.bind('select', selectHandler)
		.bind('unselect', unselectHandler)
		// add child <.icon>
		.append(
			$('<span/>').addClass('icon')
		);

	//----------------------------------
	//  Checkbox
	//----------------------------------

	// get the <input type="checkbox"> element
	var checkbox = $this.find('input:checkbox');
	if (checkbox.length <= 0) return;

	// hide the classic checkbox
	checkbox.hide();

	// update the current style
  
	update(checkbox.attr('checked'));

	//----------------------------------
	//  clickHandler
	//----------------------------------

	// event listener
	function clickHandler(e)
	{
		e.stopPropagation();
		e.preventDefault();

		// dispatch event
		$this.trigger(
			// event type
			!checkbox.attr('checked')?'select':'unselect',
			// from user interaction
			[true]
		);
	};

	//----------------------------------
	//  selectHandler
	//----------------------------------

	// event listener
	function selectHandler(e, fromUserInteraction) {
		update(true);
	}

	//----------------------------------
	//  unselectHandler
	//----------------------------------

	// event listener
	function unselectHandler(e, fromUserInteraction) {
		update(undefined);
	}

	//----------------------------------
	//  update
	//----------------------------------

	// helper : update the style and the checkbox selection
	function update(selected)
	{
    if (selected == undefined) {
      // remove the 'selected' class
      $this.removeClass('selected');
      // uncheck the original checkbox
      checkbox.removeAttr('checked');
    } else {
      // add the 'selected' class
      $this.addClass('selected');
      // uncheck the original checkbox
      checkbox.attr('checked', 'checked');
    }
	}

}); // end of return this.each...
}; // end of function
})(jQuery);


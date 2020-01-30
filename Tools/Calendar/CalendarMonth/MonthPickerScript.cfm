
<cfoutput>

    <script src='#session.root#/Scripts/MonthPicker/jquery-ui.min.js'></script>
	<script src="#session.root#/Scripts/MonthPicker/jquery.mtz.monthpicker.js" type="text/javascript"></script>
 	<link rel='stylesheet' href='#session.root#/Scripts/MonthPicker/jquery-ui.css'>
	<script>

	function __initMonthPicker(id,year,onSelect)
	{
		$('##'+id).val($('##__monthPickerMonth_'+$('##'+id+'_month').val()).val() + ' ' + $('##'+id+'_year').val());
		
		__monthPickerOptions = {
			pattern: 'yyyy-mm',
			selectedYear: eval(year)
		};
		
		$('##'+id).monthpicker('destroy');
		$('##'+id).monthpicker(__monthPickerOptions);
		
		$('##'+id).monthpicker().bind('monthpicker-click-month', function (e, month) {
			$('##'+id+'_year').val($('##'+id).val().substring(0,4));
			$('##'+id+'_month').val(parseInt($('##'+id).val().substring(5,$('##'+id).val().length)));
			
			$('##'+id).val($('##__monthPickerMonth_'+$('##'+id+'_month').val()).val() + ' ' + $('##'+id+'_year').val());
			
			if (onSelect != "") {
				eval(onSelect);
			}
		});
		
		$('##'+id+'_button').bind('click', function () {
			$('##'+id).monthpicker('show');
		});
	}	
	</script>	
</cfoutput>
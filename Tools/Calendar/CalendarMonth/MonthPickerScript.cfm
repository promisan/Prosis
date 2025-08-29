<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
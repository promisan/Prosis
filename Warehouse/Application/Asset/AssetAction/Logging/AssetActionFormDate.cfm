
<cfoutput>
<cf_tl id = "Some changes have not been saved, do you still want to continue?" class="message" var = "vSave4">

<script>
	
	var vdate = $("##RecordingDate").val();
			
	if (vdate != '') {
		
		if (changes_made)
		{
			var response = confirm('#vSave4#');
			if (response)
				do_change('#URL.adate#','#URL.scope#','#URL.Mission#','','#CLIENT.Location#');
			else
				//revert
				$("##RecordingDate").val('#URL.adate#');
					
		}	
		else
			do_change('','#URL.scope#','#URL.Mission#','','#CLIENT.Location#');
	}
	
</script>
</cfoutput>

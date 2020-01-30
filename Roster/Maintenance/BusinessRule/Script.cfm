

<script language="javascript">
	function showFields(){
	
		var list = document.getElementById('TriggerGroup');
		var type = list[list.selectedIndex].value;
	
		if (type == "Process") opposite = "Bucket"
		else opposite = "Process"
		
		var r = document.getElementById('myTable').rows;
		for (i=0; i<r.length; i++)
		{
			row = r[i];
			if (row.className==("r_"+type))
				row.style.display="";
			else if (row.className==("r_"+opposite))
				row.style.display="none";
		}
		
		// if (type == "Process")
		//	window.resizeTo(600,470);
		// else
		//	window.resizeTo(600,360);
			
	}
	
	function validateTemplate(){
		path = document.getElementById('ValidationPath').value;
		template = document.getElementById('ValidationTemplate').value;
		ColdFusion.navigate('validateTemplate.cfm?template='+path+template,'templateValidation');
	}
	
</script>
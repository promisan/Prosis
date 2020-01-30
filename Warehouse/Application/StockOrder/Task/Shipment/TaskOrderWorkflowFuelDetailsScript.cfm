
<cf_ajaxNavigate>

<cfoutput>
<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script>				
<script>



function isNull(t) {
	 if (t == '')
	 	return 'null'
	 else
	 	return t.replace(',','');
}

function textinit()
{
	$('input:text[value=""]:visible:enabled:first').focus();
}

function get_data(cl) {
	var vdata = $(cl);
	var temps = '';
	$(vdata).each(function()
	{	
		 value = isNull($(this).val());
		  if (temps == '') {
			    temps = value;
		  } else {  
			    temps = temps+","+value;
		  }
	});
	return temps;
}


function saveseal(id)
{
	$("##reference1").val(get_data(".reference1"));
	$("##reference2").val(get_data(".reference2"));
	$("##reference3").val(get_data(".reference3"));	
	ColdFusion.navigate('#SESSION.root#/warehouse/application/stockOrder/Task/Shipment/TaskOrderWorkflowFuelDetailsSubmit.cfm?id='+id,'dreturn','','','POST','fseals')
}


</script>

<style>
	.reference1 {
		text-align:right		
		cursor: text;
	}

	.reference2 {
		text-align:right		
		cursor: text;
	}

	.reference3 {
		text-align:right		
		cursor: text;
	}
	
	.title {
		font: bold 10px/24px Verdana, Arial, Helvetica, sans-serif;
	}	
	
	
</style>

</cfoutput>
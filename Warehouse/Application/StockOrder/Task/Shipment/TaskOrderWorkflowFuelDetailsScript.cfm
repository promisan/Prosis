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
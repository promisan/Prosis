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
<cfajaximport tags="cfdiv,cfform">

<cfparam name="url.scope" default="Backoffice">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="url.id" default="">
<cfparam name="url.mode" default="add">

<cfquery name="GetTopics" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT *
  FROM   Ref_Topic
  WHERE Operational = 1
  ORDER BY ListingOrder
</cfquery>

<style>

	td.Checked {
		font-weight: bold;
	}
	
	td.UnChecked {
		font-weight: normal;
	}
</style>


<cfoutput>
<script>


function get_form(c,lc)
{
	
	ColdFusion.Window.create('MDetails', 'Medical Details','',
	{x:100,y:100,height:500,width:600,
	modal:true,closable:true,draggable:false,
	resizable:true,center:true,
	initshow:true,minheight:200,minwidth:200});		

	ColdFusion.navigate('#SESSION.root#/Staffing/Portal/Warden/MedicalForm.cfm?code='+c+'&listcode='+lc,'MDetails');
		
}



function set_single(c,lc)
{
	ColdFusion.navigate('#SESSION.root#/Staffing/Portal/Warden/SingleSubmit.cfm?code='+c+'&listcode='+lc,'process');
		
}

function set_boolean(c,v)
{
	ColdFusion.navigate('#SESSION.root#/Staffing/Portal/Warden/ScalarSubmit.cfm?code='+c+'&value='+v,'process');
		
}


function set_text(c)
{
	element = document.getElementById ('Topic_'+c);
	
	if (element.value != '')
		ColdFusion.navigate('#SESSION.root#/Staffing/Portal/Warden/ScalarSubmit.cfm?code='+c+'&value='+element.value,'process');
		
}


function set_multiple(t,c,lc)
{



	if (t == 0)
	{
		element = document.getElementById ('Topic_'+c+'_'+lc);
		if (element.checked == true)
		{
			ColdFusion.navigate('#SESSION.root#/Staffing/Portal/Warden/MultipleSubmit.cfm?code='+c+'&listcode='+lc,'process');
			
			element = document.getElementById ('Topic_'+c+'_None');
			element.checked = false;
			
			td_element = document.getElementById ('TD_'+c+'_'+lc);
			td_element.className = 'Checked';

			
		}	
		else
		{
			ColdFusion.navigate('#SESSION.root#/Staffing/Portal/Warden/MultipleSubmit.cfm?action=unselect&code='+c+'&listcode='+lc,'process');			
			element = document.getElementById ('TD_'+c+'_'+lc);
			element.className = 'UnChecked';			
		}	
	}
	else
	{
	 // None option was selected 
	 
		element = document.getElementById ('Topic_'+c+'_'+lc);
		if (element.checked == true)
		{
				var inputs = document.getElementsByTagName("input"); //or document.forms[0].elements;   
				for (var i = 0; i < inputs.length; i++)
				{   
					if (inputs[i].type == "checkbox" && inputs[i].name != element.name)
					{   
						if (inputs[i].name.indexOf('Topic_'+c+'_') != -1 && inputs[i].checked == true)
						{
							//Now removing references
							vlc = inputs[i].name.replace('Topic_'+c+'_','');
							ColdFusion.navigate('#SESSION.root#/Staffing/Portal/Warden/MultipleSubmit.cfm?action=unselect&code='+c+'&listcode='+vlc,'process');			
							inputs[i].checked = false;		
				
							td_element = document.getElementById ('TD_'+c+'_'+vlc);
							td_element.className = 'UnChecked';
							
						}
				  	 }   
				} 
				
			td_element = document.getElementById ('TD_'+c+'_'+lc);
			td_element.className = 'Checked';
			// Creating a new record for this.
			ColdFusion.navigate('#SESSION.root#/Staffing/Portal/Warden/MultipleSubmit.cfm?action=none&code='+c,'process');			
			
			
		}
		else
		{
			td_element = document.getElementById ('TD_'+c+'_'+lc);
			td_element.className = 'UnChecked';
		}


		
	}		
}




</script>
</cfoutput>

<cfset url.mode = "Person">
<cfinclude template="../../../Staffing/Application/Employee/PersonViewHeader.cfm">
<table><tr><td height="2"></td></tr></table>	


<cfset url.mode = "add">

<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

  <tr>
    <td height="26">&nbsp;&nbsp;&nbsp;
	<font size="4" color="#808080" face="calibri"><b><cf_tl id="Medical"></b>
	</td>
 </tr>

<tr><td height="1" bgcolor="e4e4e4"></td></tr>
 
<tr class="hide" ><td><iframe name="process" id="process" width="100%" height="100%"></iframe></td></tr>
<tr><td valign="top" align="center">



<table width="98%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfoutput>
<cfset i = 0 >

<cfloop query="GetTopics">
	<cfif i MOD 2 eq 0>
		<tr height="10">    

	</cfif>
	   
	   <td valign="top" height="5px" style="padding:5px">
	   
		   <cf_tableRound totalheight="100%" mode="solidcolor" color="##f0f0f0" padding="5">
		   	<table width = "100%" height="100%">
			<tr>
				<td align="left" height="5px" >
				   	#ListingOrder#. #Description#
					<!---- <cfif ValueObligatory eq "1"><font color="FF0000">*</font></cfif>
					--->
				</td>
			</tr>
			<tr><td height="1" class="line"></td></tr>
			<tr>	
				<td id = "#GetTopics.code#" height="5px">				
				<cfdiv id = "box_#GetTopics.code#" onbind ="true" bind = "url:#SESSION.root#/Staffing/Portal/Warden/MedicalDetail.cfm?mode=add&id=#URL.ID#&code=#GetTopics.code#&multiple=#GetTopics.ValueMultiple#">
				</td>
			</tr>
			</table>	
			</cf_tableRound>
		</td>
		
	<cfset i = i + 1>
	
	<cfif i MOD 2 eq 0>

		</tr>
	</cfif>	
</cfloop>	

  </cfoutput>
  
</TABLE>




</td>
</tr>
</table>


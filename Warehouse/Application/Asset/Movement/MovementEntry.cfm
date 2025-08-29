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
<cfsavecontent variable="Label">

   <font face="Verdana" size="3"><b>

	<cfoutput>
		<img src="#SESSION.root#/images/logos/warehouse/transfer.png" height="30" width="40" alt="" border="0" align="absmiddle">&nbsp;
	</cfoutput>
	<cf_tl id="Transfer equipment">
	
</cfsavecontent>	

<cf_screentop height="100%" 
              scroll="Yes" 
			  title="Movement Request" 
			  label="#label#" 
			  line="no"
			  jQuery="Yes"
			  systemmodule="Warehouse"
			  FunctionClass="Window"
			  FunctionName="Asset Movement"
			  user="returnValue=1"			 
			  layout="webapp" 
			  banner="gray">

<cf_dialogMail>
<cf_dialogProcurement>
<cf_dialogOrganization>
<cf_dialogAsset>
<cf_dialogPosition>
		 	
<cfajaximport tags="cfwindow">

<cfoutput>
	
	<script language="JavaScript">
	
	function movedel(id,asset,sta,tab) {
		 if (confirm("Do you want to remove this item from the list ?"))  {
	       ColdFusion.navigate('MovementItemsDelete.cfm?id='+id+'&id1='+asset+'&actionStatus='+sta+'&table='+tab,'boxasset')			  
		 }			  
	}	
		
	function reloadForm(id,sort,view) {
	     ColdFusion.navigate('MovementItems.cfm?movementId='+id+'&sort='+sort+'&view='+view,'boxasset')		
	}  	
	
	function applyunit(orgunit) {
		ColdFusion.navigate('setUnit.cfm?orgunit='+orgunit,'process')
	}
		
	</script>

</cfoutput>

<cfquery name="Check" 
	 datasource="appsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * 
	 FROM   Ref_EntityClassPublish
	 WHERE  EntityCode   = 'AssMovement'
	 AND    EntityClass  = 'Standard'	 
</cfquery>

<cfif Check.recordcount eq "0">

	<cf_message message="No workflow has been defined" return="close">
	<cfabort>

</cfif>

<cfform action="MovementEntrySubmit.cfm?mission=#url.mission#&tbl=#url.tbl#&id=#url.id#&id1=#url.id1#&id2=#url.id2#&page=#url.page#&sort=#url.sort#&view=#url.view#&mde=#url.mde#" method="POST" target="items" name="movement" id="movement">
	
	<cfparam name="URL.MovementId" default="{00000000-0000-0000-0000-000000000000}">
	<cfparam name="Form.AssetId"   default="{00000000-0000-0000-0000-000000000000}">
	
	<cfquery name="Parameter" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM   Parameter
	</cfquery>
	
	<cfquery name="Update" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Parameter
			SET    MovementNo = MovementNo+1
	</cfquery>
	
	<table width="95%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
		
		<!--- target for the submit method --->
		<tr class="hide"><td><iframe name="items" id="items"></iframe></td></tr>
		
		<tr><td height="4"></td></tr>
		<tr><td colspan="2" align="left"><input type="reset" name="Submit" class="button10g" id="Submit" value="Reset values" style="height:23;width:150" class="button7"></td></tr>
		<tr><td height="4"></td></tr>
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>
		<tr><td height="4"></td></tr>
		<tr>
		 <td height="20" width="20%" class="labelmedium"><cf_tl id="Reference No">:</td>
		 <td class="labelmedium"><b><cfoutput>#Parameter.MovementPrefix#-#Parameter.MovementNo+1#</cfoutput></b></td>
		 <input type="hidden" name="Reference" id="Reference" value="<cfoutput>#Parameter.MovementPrefix#-#Parameter.MovementNo+1#</cfoutput>">
		</tr>
		
		<cf_calendarscript>
		
		<tr>
		  <td height="20" class="labelmedium"><cf_tl id="Effective date">:</td>
		  <td>
		  		<cf_intelliCalendarDate9
					FieldName="DateEffective" 
					class="regularxl"
					Default="#dateformat(now(), CLIENT.DateFormatShow)#"
					AllowBlank="False">	
		 </td>
		</tr> 
				
		<tr>
		  <td height="20" class="labelmedium"><cf_tl id="Move to location">:</td>
		  <td>
		  	<table cellspacing="0" cellpadding="0"><tr><td>
		     <cfoutput>
		  	  <cfif Form.AssetId neq "">	
		       <input type="button" class="button7" style="height:25;width:30px" name="search" id="search" value=" ... " onClick="selectloc('movement','location','locationcode','locationname','orgunit','orgunitname','personno','name',document.getElementById('mission').value)"> 
			  </cfif>
			  </td>
			  <td style="padding-left:2px">
			  <input type="text"   name="locationname" id="locationname"   value="" class="regularxl" size="60" maxlength="60" readonly style="text-align: left;">
		   	  <input type="hidden" name="location" id="location"     value=""> 
			  <input type="hidden" name="locationcode" id="locationcode" value="">
		     </cfoutput>
		 	 </td></tr></table>
		 </td>
		</tr> 
							
		<cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Ref_Mandate
			WHERE    Mission = '#url.Mission#'
			ORDER BY MandateDefault DESC
		</cfquery>
				    
		<tr>
		 <td height="20" class="labelmedium"><cf_tl id="Responsible unit">:</td>
			 <td>
			 
			 	<table cellspacing="0" cellpadding="0"><tr><td>
		        <cfoutput>
				
				<cfif Form.AssetId gte "">	
		        <input type    = "button" 
				       class   = "button7" 
					   style   = "height:25;width:30px"
					   name    = "search" 
					   id      = "search"
					   value   = " ... " 
					   onClick = "selectorgmisn(document.getElementById('mission').value,document.getElementById('mandateno').value,'')"> 
				</cfif>
				</td>
				<td style="padding-left:2px">
				<input type="text"   name="orgunitname"    id="orgunitname"  value="" class="regularxl" size="60" maxlength="60" readonly style="text-align: left;">
				<input type="hidden" name="orgunitclass" id="orgunitclass"   value=""> 
				<input type="hidden" name="mandateno"    id="mandateno"      value="#Mission.MandateNo#">
				<input type="hidden" name="orgunit"      id="orgunit"        value=""> 
				<input type="hidden" name="mission"      id="mission"        value="#url.Mission#">
				<input type="hidden" name="orgunitcode"  id="orgunitcode"    value="">
				</cfoutput>
				</td>
				<td id="process"></td>
				</tr></table>
				
			 </td>
		</tr> 
		
		<tr>
		 <td height="20" class="labelmedium"><cf_tl id="Transfer to">:</td>
		 <td>
		 
		 	<cfoutput>	
		 	<table cellspacing="0" cellpadding="0">
			<tr>
			<td>							
			<cfif Form.AssetId gte "">	
			   <input type="button" class="button7" style="height:25;width:30px" name="search0" id="search0" value=" ... " onClick="selectperson('webdialog','personno','indexno','lastname','firstname','name','','#url.Mission#')"> 
			</cfif>
			</td>
			<td style="padding-left:2px">
				<input type="text"    name="name"      id="name"     class="regularxl" size="60" maxlength="60" readonly style="text-align: left;">
				<input type="hidden"  name="indexno"   id="indexno"   value="" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
				<input type="hidden"  name="personno"  id="personno"  value="">
			    <input type="hidden"  name="lastname"  id="lastname"  value="">
			    <input type="hidden"  name="firstname" id="firstname" value="">			
			</td>
			</tr>
			</table>
			</cfoutput>	
		 
		 </td>
		</tr>
		
		<tr><td height="4"></td></tr>
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>
		<tr><td height="4"></td></tr>
		
		<!--- -------------------------------------------------- --->
		<!--- box to hold the info to be processed on the assets --->
		<!--- -------------------------------------------------- --->		
		<tr><td colspan="2" id="boxasset"></td></tr>
		
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>
		<tr><td height="4" id="testing"></td></tr>
		<tr><td colspan="2" align="center">
		
		<cfif Form.AssetId neq "">
		
			<cfoutput>
			
			<cf_tl id="Transfer Items" var="1">					
			<input type="submit" name="Submit" id="Submit" value="#lt_text#" class="button10g" style="width:180;height:26">
			</cfoutput>
			
		</cfif>
		</td></tr>
		
	</table>
	
</cfform>

<cf_screenbottom layout="webapp">

<!--- -------------------------------------------------- --->
<!--- retrieve the information from the calling template --->
<!--- -------------------------------------------------- --->

<!--- --------------PENDING to be used--------------- --->
<!--- form variable to hold data to be captured as se --->
<input type="hidden" name="selectedassetid" id="selectedassetid">
<!--- ----------------------------------------------- --->

<cfoutput>

<script language="JavaScript">
		
	se = opener.get_selected_assets()				
	ColdFusion.navigate('MovementGetAsset.cfm?mission=#url.mission#&assetid='+se,'boxasset')	
	
</script>

</cfoutput>
<!--
    Copyright © 2025 Promisan

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

<cfquery name="class" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_WarehouseLocationClass	
</cfquery>

<cfform onsubmit="return false" name="locationform">

<table width="95%" align="center" class="formpadding formspacing">

<TR class="labelmedium2">

	   <td><cf_tl id="Class"></td>
				
	   <td>
	   				   
	   <select name="LocationClass" id="LocationClass" class="regularxxl">
			<cfoutput query="class">
				<option value="#code#">#Description#</option>
			</cfoutput>
	   </select>				   
	   
	   </td>
	   
</tr>	
<TR class="labelmedium2">

	<td><cf_tl id="Id">*)</td>

	 <td>
	 
		 <table>
		 <tr><td>
			
			    <cfinput type="Text" 
			         value="" 
					 name="Location" 
					 message="You must enter a location id" 
					 required="Yes" 
					 size="4" 
					 onkeyup="removeBlankSpaces(this);ptoken.navigate('#session.root#/Warehouse/Maintenance/WarehouseLocation/getCodeCheck.cfm?warehouse=#url.warehouse#&value='+this.value,'codecheck')"
					 onblur="removeBlankSpaces(this)"
					 maxlength="10" 
					 class="regularxl">
					 
		</td>
		
		<td style="padding-left:4px" id="codecheck"></td>
		</tr>				 
		</table>
	
    </td>
			
</tr>		

<TR class="labelmedium2">

		<td><cf_tl id="Descriptive">*)</td>
   		   				   
	   <td>
	   	   <cfinput type="Text" 		   	
			name="Description" 
			message="You must enter a descriptive" 
			required="Yes" 
			style="width:97%"						
			maxlength="100" 
			class="regularxxl">
	  
          </td>
		  
</tr>

<tr class="labelmedium2">		

	   <td><cf_tl id="Barcode"></td>	  
	   
	   <td>
	   	<cfinput type="Text" 
	         name="StorageCode" 
			 message="You must enter a barcode" 
			 required="No" 
			 style="width:120px"			 
			 maxlength="20" 
			 onkeyup="removeBlankSpaces(this)"
			 onblur="removeBlankSpaces(this)"
			 class="regularxxl">
	  </td>		
	  
</tr>

<tr class="labelmedium2">	  
		 
	   <td><cf_tl id="Picking Priority">*)</td>	 	   
	   <td>
	   
	   	<cfinput type="Text"
		       name="ListingOrder"		       
			   class="regularxxl"
		       validate="integer"
			   value="1"
		       required="Yes"
			   message="Please enter a order value" 
		       visible="Yes"		       				 			      
		       maxlength="2"
			   style="width:30px;text-align:center">
	   			   
	   </td>
		 
</tr>

<tr class="labelmedium2">			
	   <td><cf_tl id="Operational"></td>		   
	   <td><input type="checkbox" class="radiol" name="Operational" id="Operational" value="1" checked></td>	   
</tr>

<tr>	   	   				  
	<td class="line" colspan="2" align="center" style="height:40px;padding-left:4px" id="addlocation">	   
	   	<input type="submit" value="Save" class="button10g" onclick="locationsave()">			
	</td>				
</TR>	

</table>

</cfform>
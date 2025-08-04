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

<cf_textareascript>

<cfparam name="url.memoid" default="">
<cfparam name="form.CustomerMemo" default="">

<cfif url.memoid neq "">

	<cfset memoid = url.memoid>

</cfif>

<cfif form.CustomerMemo neq "">

	<cfquery name="Check" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   CustomerMemo
		WHERE  CustomerId = '#URL.CustomerId#'
		AND    MemoId = '#memoid#'		
	</cfquery>
	
	<cfif Check.recordcount eq "0">

		<cfquery name="Memo" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO CustomerMemo
			(CustomerId, MemoId, CustomerMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES
			('#URL.CustomerId#','#memoid#','#form.CustomerMemo#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')			
		</cfquery>
			
	<cfelse>
	
		<cfquery name="update" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE CustomerMemo
			SET CustomerMemo = '#form.CustomerMemo#'
			WHERE   CustomerId = '#URL.CustomerId#'
			AND MemoId = '#memoid#'						
		</cfquery>	
	
	</cfif>
	
	<cfset url.memoid = "">
	
</cfif>

<cfquery name="Memo" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   CustomerMemo
	WHERE   CustomerId = '#URL.CustomerId#'
	ORDER BY Created DESC
</cfquery>

<cfform name="memoform" id="memoform">
	
	<table width="95%" align="center" class="navigation_table">
	  	
	<tr class="labelmedium2 line">
	    <td height="20" style="min-width:30px"></td>
		<td><cf_tl id="Memo"></td>
		<td><cf_tl id="Officer"></td>
		<td style="min-width:120px"><cf_tl id="Date/Time"></td>
		<td style="width:20px" align="center"></td>	
	</tr>
		
	<cfoutput query="Memo">
	
	<cfif url.memoid eq memoid and form.CustomerMemo eq "" and SESSION.acc eq OfficerUserId>
	
		<tr bgcolor="ffffff" class="line">
		   <td valign="top" style="padding-top:5px" height="20">#currentrow#.</td>
		   <td bgcolor="ffffff" colspan="3" style="padding:3px">
			
			<!---			 
			<textarea name="CustomerMemo"
				color   = "ffffff"
				toolbar = "mini"	 
				init    = "no"		
				height  = "80"		 
				style   = "border:0px;font-size:14px;background-color:f1f1f1;font-size:14px;padding:3px;width:100%;height:50px">#CustomerMemo#</textarea>
				
				--->
				
				<!--- toolbar        = "basic" --->
			
		   <cf_textarea name="CustomerMemo"
		       toolbar        = "mini"                                          		   
			   resize         = "true"
			   border         = "0"
			   init           = "false"
			   height         = "130"
			   color          = "ffffff">#CustomerMemo#</cf_textarea>		
				
		  </td>
		  </tr>
		  <tr class="line">
		  <td colspan="5" align="center"  valign="bottom" style="padding-top:3px;padding-right:4px;padding-bottom:3px">
				<input type="button" 
				  name="Save" 
				  value="Save" 
				  class="button10g" 
				  style="width:160px;height:25px" 
				  onclick="updateTextArea();_cf_loadingtexthtml='';ptoken.navigate('CustomerMemo.cfm?CustomerId=#url.CustomerId#&memoid=#memoid#','contentbox2','','','POST','memoform')">
		</td></tr>
		
	<cfelse>
	
	
	    <cfif SESSION.acc eq OfficerUserId>
		<tr class="labelmedium2 navigation_row line">
		<cfelse>
		<tr class="labelmedium2 line">
		</cfif>
		    <td height="20" style="padding-left:3px">#currentrow#.</td>
			<td style="padding-left:18px;padding-right:20px">#paragraphformat(CustomerMemo)#</td>
			<td class="fixlength">#OfficerLastName#</td>
			<td class="fixlength">#dateformat(created,CLIENT.DateFormatShow)# #timeformat(created,"HH:MM")#</td>
			<td align="center" style="padding-top:1px;padding-right:4px">		
			<cfif SESSION.acc eq OfficerUserId>
			<cf_img icon="open" navigation="Yes" onclick="_cf_loadingtexthtml='';ptoken.navigate('CustomerMemo.cfm?CustomerId=#url.CustomerId#&memoid=#memoid#','contentbox2')">
			</cfif>
			</td>
		</tr>
	
	</cfif>
		
	</cfoutput>
	
	<cfif url.memoid eq "">
	
	<cf_assignId>
	<cfset memoid = rowguid>	
	
	<tr bgcolor="ffffff" class="line">
	<td valign="top" style="padding-left:3px;padding-top:5px"><cfoutput>#memo.recordcount+1#.</cfoutput></td>
	<td colspan="4" style="padding:3px">
	
	     <cf_textarea name="CustomerMemo"
		       toolbar        = "mini"                                          		   
			   resize         = "false"
			   init           = "false"
			   border         = "0"
			   height         = "130"
			   color          = "ffffff"></cf_textarea>		
			   
			   <!---
		<textarea 
			name="CustomerMemo"
				color   = "ffffff"
				toolbar = "mini"	 
				init    = "no"
				height  = "80" 				 
				style="border:0px;background-color:f1f1f1;font-size:14px;padding:3px;width:100%;"></textarea>
				
				--->
	</td>
	</tr>
	<tr>
	<td colspan="5" align="center" style="padding-right:4px;padding-bottom:3px;padding-top:3px">
	 <cfoutput>
			<input type="button" 
			    name="Save" 
				value="Save" 
				style="width:160px;height:25" 
				class="button10g" 
				onclick="updateTextArea();_cf_loadingtexthtml='';ptoken.navigate('CustomerMemo.cfm?CustomerId=#url.CustomerId#&memoid=#memoid#','contentbox2','','','POST','memoform')">
		</cfoutput>
	</td>
	
	</tr>
	
	<tr><td height="3"></td></tr>

	</cfif>

</table>

</cfform>


<cfset AjaxOnLoad("doHighlight")>	

<cfset AjaxOnLoad("initTextArea")>

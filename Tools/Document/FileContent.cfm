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
<cf_screentop height="100%" scroll="no" html="No">   

<cfif ParameterExists(Form.Save)> 
			
	<cffile action="WRITE"
	    file="#url.path#"
	    output="#Form.SQL#"
	    addnewline="Yes"
	    fixnewline="No"> 		
		
	<script>alert("Saved")</script>	
	
</cfif>	

<cfform style="height:100%"
     action="FileContent.cfm?openas=#url.openas#&mode=#url.mode#&path=#url.path#" 
	 method="post">
   
	<table height="100%" width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr class="line"><td align="center" height="25">	
	
	    <!---
		<input type="button" name="Cancel" id="Cancel" style="width:100px;height:25px" value="Cancel" class="button10g" onclick="parent.window.close()">
		--->
			
		<cfif url.openas eq "Edit" or url.mode eq "report"> 
			<input type="submit" name="Save" id="Save" style="width:100px;height:25px" value="Save" class="button10g">
		</cfif>
		
		<cfif find(".cfm",  path) or find(".cfc",  path)>
		<cfif ParameterExists(Form.Format)>
			<input type="submit" name="Edit"   id="Edit"   style="width:100px;height:25px" value="Edit"      class="button10g">	
		<cfelse>
			<input type="submit" name="Format" id="Format" style="width:100px;height:25px" value="Formatted" class="button10g">	
		</cfif>
		</cfif> 
	
	</td></tr>
		
	<tr><td height="100%" valign="top">
	
	<cfif ParameterExists(Form.Edit) or ParameterExists(Form.Format)>
	
	    <!--- take content from form --->
		<cfset content = form.SQL>
		
		<cfif ParameterExists(Form.Edit)>
		
			<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding">
			<tr><td width="100%" height="100%">
		
			<cfoutput>
			
			<textarea name="SQL"
		          class="regular0"
		          style="width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
			</cfoutput>
			
			</td></tr></table>	
			
		<cfelse>
		
			<table width="100%" height="100%" cellspacing="0" cellpadding="0">
			<tr>
			<td class="hide">
			
			<cfoutput>
			<textarea name="SQL"	         
		          style="width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
			</cfoutput>
			
			</td>
			</tr>
			
			<tr>
			<td valign="top" style="border:0px dotted silver" width="100%" height="100%">
		
		    <cf_divscroll>
			<cfinvoke component="Service.Presentation.ColorCode"  
				      method="colorstring" 
				      datastring="#content#" 
				      returnvariable="result">			
		              <cfset result = replace(result, "�", "", "all") />
					  <cfoutput>			   			  
					  #result#	
					  </cfoutput>
			</cf_divscroll>		  
					  
			</td>		  
					  
			</tr>
			</table>		  
		
		</cfif>	
	
	<cfelse> 
				
	   <cffile action="READ" 
		   file="#url.path#" 
		   variable="content">
				
		<table width="100%" height="100%" style="border:0px dotted silver" cellspacing="0" cellpadding="0" class="formpadding">
		<tr><td width="100%" height="100%" style="padding-left:10px">
			
				<cfoutput>
					<textarea name="SQL"
		    	      class="regular0"
		        	  style="width: 100%; height: 100%; word-break: break-all;">#content#</textarea>
				</cfoutput>
		
		</td></tr>
		</table>
		
	</cfif>	
	
	</td></tr>
	
	</table>

</cfform>

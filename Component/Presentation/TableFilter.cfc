
<cfcomponent>

    <cfproperty name="name" type="string">
    <cfset this.name = "Table Filtering Functions">
	
	<!--- 1.0 GENERAL ACCESS TO A FUNCTION --->
	
	<cffunction access="public" name="tablefilterfield" output="true" returntype="string" 	displayname="Table filter">
					
		<cfargument name="name"          default="filtersearch"   required="yes">
		<cfargument name="filtermode"    default="enter"          required="yes">
		<cfargument name="style"         default="font:10px"      required="no">
		<cfargument name="rowclass"      default="row"            required="yes">
		<cfargument name="rowfields"     default="field"          required="yes">
		<cfargument name="icon"          default="finger.gif"     required="yes">
		<cfargument name="label"         default="Search"         required="yes">
		<cfargument name="displayValue"  default=""      		  required="no">
		<cfargument name="filterLabel"   default="filtered"       required="no">
		
		<cfset passtru = "">
		<cf_tl id="#label#" var="vLabel">
		<cf_tl id="#filterLabel#" var="vFilterLabel">
		
		<cfif displayValue eq "table-row" and find("MSIE 7","#CGI.HTTP_USER_AGENT#")>
			<cfset displayValue = "block">
		</cfif>
					   		
		<cfoutput>		
			
			<cfloop index="field" list="#rowfields#">
				<cfif passtru eq "">
					<cfset passtru = ".#rowclass# .#field#">
				<cfelse>
				    <cfset passtru = "#passtru#, .#rowclass# .#field#">
				</cfif>
			</cfloop>				
			
	   	    <table>
			<tr>
			    
			    <td><!---<img src="#SESSION.root#/images/#icon#" border="0">---></td>
				
				<td style="padding-left:6px;height:35px" class="labelit">#vLabel#:</td>
				<td align="right" style="padding-left:5px">
					<cf_tl id="Search by any text" var="1">					
					<input type="text" style="#style#" class="regularxl" id="#name#search" name="#name#search" size="30" 
					 onkeyup="__prosisPresentation_do_tablesearch(event,'#filtermode#','#name#','#rowclass#','#passtru#','#displayValue#','#vFilterLabel#');" title="#lt_text#">
					 
					 <!--- removes the 'X' from the input in IE10 --->
					 <style>
					 	###name#search::-ms-clear
						{
						  width : 0;
						  height: 0;
						}
					 </style>
					 
				</td>
				<td width="20" style="padding-left:1px;" align="center" class="labelit" onclick="__prosisPresentation_do_clearsearch(event,'#filtermode#','#name#','#rowclass#','#passtru#','#displayValue#','#vFilterLabel#');">
					<cf_tl id="Clear search" var="1">
					<img src="#session.root#/images/Clear.png" align="absmiddle" title="#lt_text#" height="36px" style="cursor:pointer;">
				</td>		
				<td width="30" style="padding-left:3px; color:red; font-size:11px;" class="#name#counter labelit" align="right"></td>
				<td width="20" style="padding-left:5px;">
					<span id="#name#busy" style="display:none;">							
						<img src="#SESSION.root#/images/busy10.gif" height="15">							
					</span>
				</td>
			</tr>
			</table>
					
		</cfoutput>
				
	</cffunction>	
	
</cfcomponent>	
	

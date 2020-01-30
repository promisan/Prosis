
<cfparam name="url.mission" default="">

<cfif url.mission eq "">
	  <cfabort>
</cfif>

<cf_layoutscript>
<cfajaximport tags="cfform">
		 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<cf_layoutarea 
	    position="left" 
		name="treebox" 
		maxsize="300" 		
		size="200" 
		collapsible="true"		
		splitter="true">
		
		<cfform>
		
		<table width="100%">

			<tr class="line labelmedium"  style="background-color:eaeaea;height:60px">
				<td align="center" style="padding-left:5px;height:40px">
				<cfoutput>	
				<select name="operational" id="operational" class="regularxl" style="background-color:f1f1f1;height:28px;font-size:18px;width:90%" onchange="ptoken.navigate('RateViewTree.cfm?idmenu=#url.idmenu#&location=#url.location#&schedule=#url.schedule#&mission=#url.mission#&operational='+this.value,'treeview')">
						<option value="1" selected><cf_tl id="Active"></option>
						<option value="0"><cf_tl id="Deactivated"></option>
				</select>
				</cfoutput>
				</td>
			</tr>
			
			<tr>
				<td id="treeview">				
				<cfinclude template="RateViewTree.cfm">			
				</td>
			</tr>
		</table>	
			
		</cfform>	
	
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box">
				
			<iframe name="right"
		        id="right"
		        width="100%"
		        height="100%"				
				scrolling="no"
		        frameborder="0"></iframe>
									
	</cf_layoutarea>			
		
</cf_layout>

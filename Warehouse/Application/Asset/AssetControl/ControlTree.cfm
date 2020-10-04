
<cfoutput> 
		
<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#url.mission#" 
	   role              = "'AssetHolder'"	   
	   anyunit           = "No"
	   accesslevel       = "'1','2'"
	   returnvariable    = "accessright">	
	   
  
<table width="100%" cellspacing="0" cellpadding="0" class="tree formpadding">
	  	 
<cfif accessright eq "GRANTED">	 
	
	<tr><td height="3"></td></tr>
	<tr class="hide"><td height="3"></td><td><cfdiv name="drefresh" id="drefresh"/></td></tr>
	
	<tr>
	<td class="labelmedium" style="height:20;padding-left:10px">
	<table><tr class="labelmedium"><td>
	<img style="width: 18px;" src="#SESSION.root#/images/Edit.png" alt="" border="0">
	</td>
	<td class="labelmedium" style="padding-top:2px;font-size:16px;padding-left:10px">
	<a href="javascript:newreceipt()"><cf_tl id="Register New Asset"></a>
	</td></tr></table>
	</td>
	<td align="right" style="padding-right:10px">
		<img src="#client.virtualdir#/images/Refresh-Orng.png" alt="tree refresh" border="0" onclick="javascript:tree_refresh()"
		 style="cursor:pointer;width: 20px;padding: 4px 6px 0 0;">
	</td>
	</tr>	
    <tr>
	<td class="labelmedium" style="height:20;padding-left:10px">
	<table><tr class="labelmedium"><td>
	<img style="width: 18px;" src="#SESSION.root#/images/Edit.png" alt="" border="0">
	</td>
	<td class="labelmedium" style="padding-top:2px;font-size:16px;padding-left:10px">
	<a href="javascript:depreciation()"><cf_tl id="Depreciation"></a>
	</td></tr></table>
	</td>
	
	<td></td>
	
	</tr>
    	
	<tr><td colspan="2" class="linedotted"></td></tr>

</cfif>

</cfoutput>

<tr><td valign="top" colspan="2" style="padding-top:6px;padding-left:8px">

<cfinclude template = "TreePreparation.cfm">	

<cfform>
	<cftree name="tmaterials" font="Calibri" fontsize="12" format="html" required="No">
		   	 <cftreeitem 
				  bind="cfc:Service.Process.Materials.Tree.getNodes({cftreeitemvalue},{cftreeitempath},'#url.Mission#')">  		 
	</cftree>			
</cfform>

</td></tr></table>


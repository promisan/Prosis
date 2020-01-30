
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
	<img style="width: 18px;position: relative;top: 5px;" src="#SESSION.root#/images/Edit.png" alt="" border="0">
	<a href="javascript:newreceipt()"><font color="0080C0"><cf_tl id="Register New Asset"></font></a>
	</td>
	<td align="right">
		<img src="#client.virtualdir#/images/Refresh-Orng.png" alt="tree refresh" border="0" onclick="javascript:tree_refresh()" style="cursor:pointer;width: 28px;padding: 4px 6px 0 0;">&nbsp;&nbsp;
	</td>
	</tr>
	<tr>
        <td>
        </td>
    </tr>
    <tr>
	<td class="labelmedium" style="height:20;padding-left:10px">
	<img style="width: 18px;position: relative;top: 5px;" src="#SESSION.root#/images/Edit.png" alt="" border="0">
	<a href="javascript:depreciation()"><font color="0080C0"><cf_tl id="Depreciation"></font></a>
	</td>
	
	<td></td>
	
	</tr>
    <tr>
        <td height="20">
        </td>
    </tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>

</cfif>

</cfoutput>

<tr><td valign="top" colspan="2" style="padding-top:6px;padding-left:5px">

<cfinclude template = "TreePreparation.cfm">	

<cfform>
	<cftree name="tmaterials" font="Calibri" fontsize="12" format="html" required="No">
		   	 <cftreeitem 
				  bind="cfc:Service.Process.Materials.Tree.getNodes({cftreeitemvalue},{cftreeitempath},'#url.Mission#')">  		 
	</cftree>			
</cfform>

</td></tr></table>


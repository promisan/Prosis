
<script language="JavaScript1.2">

function refreshTree() {
	location.reload();
}

</script>
 <cfform> 
<table width="100%" cellspacing="0" cellpadding="0" align="center">
	<tr><td style="padding-left:10px">
		
		<table width="98%" cellspacing="0" cellpadding="0" align="left" class="formpadding">
		
		<tr><td class="labelit" style="padding:3px">
			<a href="javascript:refreshTree()" target="left"> 
		     Refresh</a>
		    </td>
		</tr>
		
		<tr><td style="padding-left:10px;padding:4px" style="border-top:1px dotted silver">
		   <cf_ApplicantAccessTreeData 
		   		iconpath="#SESSION.root#/Tools/Treeview/Images">
			</td>
		</tr>
		</table>
	
	</td></tr>

</table>
</cfform>
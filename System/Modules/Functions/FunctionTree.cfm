
<cfoutput>

<script language="JavaScript">

function refreshTree() {
	location.reload();
}

</script>
</cfoutput>

<cfset Criteria = ''>

<table width="100%" height="100%" align="center" class="tree">

   <tr><td valign="top" style="padding-left:6px">
    <table width="97%" align="center">
		
	  <tr class="line"><td style="height:20px"></td></tr>
	  <tr><td style="height:10px"></td></tr>		  
	  
      <tr><td><cf_FunctionTreeData></td></tr>
    </table></td>
  </tr>
</table>


<cfquery name="get" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Request R, Item I
	  WHERE  RequestId = '#URL.RequestId#'
	  AND    R.ItemNo = I.ItemNo
</cfquery>

<cfquery name="Current" 
	  datasource="AppsMaterials" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  SELECT  * 
	  FROM    RequestTask			  
	  WHERE   RequestId    = '#URL.RequestId#'
	  AND     TaskSerialNo = '#URL.SerialNo#'
</cfquery>

<cfset url.taskedwarehouse = current.sourceWarehouse>

<table width="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<tr><td colspan="1" height="35">
<table cellspacing="0" cellpadding="0">
<tr>
	<td class="labelmedium" style="font-size:25px"><cf_tl id="Ship from internal stock">:</td>
	<td style="padding-left:4px"></td>
</tr>
</table>

</td></tr>

<tr><td id="internaldetail">

	<cfinclude template="TaskViewInternalDetail.cfm">
	
</td></tr>

</table>


<cfoutput>
<script>
	Prosis.busy('no')
	parent.taskrefresh('#url.requestid#')
</script>
</cfoutput>
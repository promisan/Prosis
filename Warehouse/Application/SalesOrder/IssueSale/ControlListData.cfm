
<!--- filter values from ControlListLocate.cfm --->
  

<table width="95%" height="100%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">


  <tr><td class="labelmedium" style="padding-top:10px">
<!--- 16/10/2015 find sale transactions, that do have a stock left in this warehouse as it was kept for the customer
, so the stock can be issued to the customer picking it up etc --->


- Customer buys, but will not take stuff home, so the sale is a transfer from warehouse to warehouse sold in order to get stock out from the on-hand.

<br>

- The returning customer will come to pick-up his stuff and this screen will contain a listing of sales transactions that have not been fully depleted

<br>

- Opening the batch will allow you to deplete +/+ until it reaches 0 

<br>

- The issuances of the stock will show in the same batch screen as -/- under the +/+


</td></tr>

<tr>

<td colspan="1" align="right" height="100%">

   <!--- <cfset url.currency      = form.currency>
   <cfset url.category      = form.category>
   <cfset url.selectiondate = form.selectiondate> 

   <cfinclude template="ControlListDataContent.cfm">
   
   --->
					
</td>

</tr>					
	
</table>


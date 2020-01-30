
    <cfparam name="Attributes.Size" default="93%"> 
	<cfparam name="Attributes.Margin" default="10">
	 <cfparam name="Attributes.bgcolor" default="ffffff">
<cfoutput>
    <!--- </table>  --->
     	
        </TD>
        <TD width="<cfoutput>#Attributes.Margin#</cfoutput>" BGCOLOR="#Attributes.bgcolor#" style="padding:0px"></TD>
        <TD bgcolor="CCCCCC" width="1" style="padding:0px"></TD>
      </TR>
    </TABLE>
	<TABLE WIDTH="<cfoutput>#Attributes.Size#</cfoutput>" ALIGN="CENTER" BORDER="0" CELLSPACING="0" CELLPADDING="0">
      <TR BGCOLOR="#Attributes.bgcolor#">
	    
        <TD width="6" style="padding:0px" class="noprint"><img src="#SESSION.root#/Images/tableblhs.gif" WIDTH="6" HEIGHT="6"></TD>
        <TD width="100%" style="padding:0px" ><img src="#SESSION.root#/images/TableMidBottom.gif" WIDTH="100%" HEIGHT="6"></TD>
        <TD width="6" style="padding:0px" class="noprint"><img src="#SESSION.root#/Images/tablebrhs.gif" WIDTH="6" HEIGHT="6"></TD>
		
      </TR>
      <TR><TD colspan="3" BGCOLOR="#Attributes.bgcolor#" height="10" style="padding:0px"></TD></TR>
    </TABLE>	
	
</cfoutput>					   
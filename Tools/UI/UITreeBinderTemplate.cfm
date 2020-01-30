<!---
https://docs.telerik.com/kendo-ui/framework/templates/overview
Kendo UI Templates use a simple templating syntax we call "hash templates."
With this syntax, the "#" (or hash) symbol is used to mark areas in a template
that should be replaced with data when the template is executed.

There are three ways to use the hash syntax:

    Render literal values: #= #
    Render HTML-encoded values: #: #
    Execute arbitrary JavaScript code: # if(...){# ... #}#
--->
<cfoutput>
    <cfsavecontent variable="_tree_template">
    ##
    var vSize = 12;
    switch(item.level()) {
    case 0:
        vSize = 17;
        break;
    case 1:
        vSize = 15;
        break;
    case 2:
        vSize = 14;
        break;
    }

    vImage = false;
    if (item.IMG)
    {
        if (item.IMG != '')
        {
            vImage = true;
        }
    }
    ##
    ## if (vImage) { ##
        <img src=##=item.IMG## style='width:18px;height:auto;border:0px;top:0;padding-right:3px'>
        <div style='font-size:##=vSize##px;font-family:Helvetica;line-height: 18px;'>##=item.DISPLAY##</div>
    ## }
    else
    { ##
        <div style='font-size:##=vSize##px;font-family:Helvetica;line-height: 18px;'>##=item.DISPLAY##</div>
    ## } ##
    </cfsavecontent>

    <div name="_prosis-tree-template"
          id="_prosis-tree-template"
           class="hide">
        #_tree_template#
    </div>
</cfoutput>

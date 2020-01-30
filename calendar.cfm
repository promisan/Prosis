<cf_screentop height="100%"  html="No" jquery="Yes">

<script>
    function onChange() {
        var range = this.range();
        console.log("Change :: start - " + kendo.toString(range.start, 'd') + " end - " + kendo.toString(range.end, 'd'));
    }

</script>

<form action="DateRangeSubmit.cfm" id="form1"  method="post" >
<!--- month/day/year--->
<cf_intelliCalendarDate10
            FieldName="Range1"
            DateValidStart="10/01/2019"
            DateValidEnd="10/20/2019"
            startLabel = "Inicio"
            endLabel = "Fin"
            OnChange="onChange"
            position="vertical">
<!---
    <cfset AjaxOnLoad("ProsisUI.doCalendar")>
--->

    <button type="submit" form="form1" value="Submit">Submit</button>

</form>
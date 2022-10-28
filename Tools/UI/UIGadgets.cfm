<cfparam name="attributes.style" 		default="default-v2"> <!--- possible values: silver, flat --->
<cfparam name="attributes.gadget" 		default="all"> <!--- possible values: silver, flat --->
<cfparam name="attributes.jquery" 		default="no"> <!--- possible values: silver, flat --->
<cfparam name="attributes.treeTemplate"	default="no"> <!--- possible values: silver, flat --->

<cfoutput>

	<link rel="stylesheet" href="#Session.root#/scripts/kendoui/styles/kendo.common.min.css" />
	<link rel="stylesheet" href="#Session.root#/scripts/kendoui/styles/kendo.#attributes.style#.min.css" />
	<link rel="stylesheet" href="#Session.root#/scripts/kendoui/styles/kendo.default.mobile.min.css" />

    <link rel="stylesheet" href="#Session.root#/scripts/kendoui/styles/kendo.rtl.min.css"/>
    <link rel="stylesheet" href="#Session.root#/scripts/kendoui/styles/kendo.silver.min.css"/>

	<cfif attributes.gadget eq "all">

		<script src="#Session.root#/scripts/kendoui/js/kendo.all.min.js"></script>
		<script src="#Session.root#/scripts/kendoui/js/cultures/kendo.culture.en-NL.min.js"></script>

	<cfelseif attributes.gadget eq "notification">

		<script src="#Session.root#/scripts/kendoui/js/kendo.core.min.js"></script>
			<script src="#Session.root#/scripts/kendoui/js/kendo.fx.min.js"></script>
			<script src="#Session.root#/scripts/kendoui/js/kendo.popup.min.js"></script>
			<script src="#Session.root#/scripts/kendoui/js/kendo.notification.min.js"></script>

	</cfif>

	<script type="text/javascript" src="#SESSION.root#/Scripts/js-cookie/js.cookie.js"></script>

	<style>

		.k-dropdowntree .k-multiselect-wrap, .k-multiselect .k-multiselect-wrap {
			border-color: rgba(0,0,0,.20) !important;
		}

		.k-dropdown .k-state-default
		{
			background-color: white;
			background-image: none;
		}

		.k-multiselect-wrap {
			font-style: normal;
			opacity: 0.6;
			color: grey;
			font-size: 14px;
		}

		.k-multiselect-wrap .k-select {
			position: relative !important;
		}

		.k-list .k-item.k-state-hover.k-state-selected {
			background-color: ##1984c8  !important;
		}

		.k-list .k-item.k-state-selected {
			background-color: ##1984c8  !important;
		}

		.k-button {
			color: ##000000 !important;
		}

		.k-multiselect-wrap {
			opacity : 100 !important;
		}

		.k-menu:not(.k-context-menu)>.k-item {
			color: ##033f5d;
		}

		.k-loading-image {
			background-image: none !important;
		}
		
		.k-loading-image::before {
			display:none !important;
		}

		.k-loading-image::after	{
			display:none !important;
		}

		.k-in {
			height: 16px;
			margin: 1px 0;
		}

	</style>

	<div id="_UIDialog" style="display:none"></div>

	<script type="text/javascript">

	var _WINDOWS=[];
	var _TREES=[];
	var _SELECTED_ITEMS=[];
	var _DEFAULT_LEVEL_ = 0;
	
	function _UIObject(){}

	var getEffects = function () {
		return ("");
	};


	_UIObject.prototype.createWindow = function (f, t, src, params) {
		params["actions"] = new Array();
		//params["actions"].push("maximize");

		if (params["minimize"]) {
			params["actions"].push("minimize");
		}

		if (params["maximize"]) {
			params["actions"].push("maximize");
		}


		if (params["closable"]==false) {
			//params["actions"].push("pin");
		}
		else {
			params["actions"].push("close");
		}


		if (!params["iframe"])
			params["iframe"] = false;

		params["content"] = src;
		params["title"] = t;
		params["fadeIn"] = false;
		params["autoFocus"] = false;

		params["deactivate"] = function () {
			this.destroy();
		}


		//console.log(params);
		if (!params["animation"]) {
			params.animation = { open: { effects: getEffects() }, close: { effects: getEffects(), reverse: true} };
		}

		if (!$('##'+f).length){
			$("##_ProsisUI").append("<div id='"+f+"' name='"+f+"' style='display:none'></div>");
		}


		$('##'+f).kendoWindow(params).data("kendoWindow").open()

		if (params["color"])
			$(".k-content").css('background-color',params["color"]);

		if (params["center"])
			$('##'+f).data("kendoWindow").center();
			
		_WINDOWS.push(f);

}

_UIObject.prototype.minimizeWindow = function (f) {
	$('##'+f).data("kendoWindow").minimize();

}

_UIObject.prototype.last =  function() {
  if (_WINDOWS == null) 
    return void 0;  
    return _WINDOWS[_WINDOWS.length - 1];
}

_UIObject.prototype.setWindowTitle = function(t,c,fc){

	var lastElement = this.last();	
	//var dialog = $("##"+lastElement).data("kendoWindow");
	//$("##"+lastElement+"_wnd_title").html('<img src="#session.root#/images/logos/menu/prosis-icon.png" style="cursor:pointer;padding-right:10px" height="24" width="24" title="Function" border="0" onclick="##">'+t);
	$("##"+lastElement+"_wnd_title").html(t);	
	$(".k-window-titlebar").css('border-color',c);	
	$(".k-window-titlebar").css('background',c);	
	$(".k-window-title").css('color',fc);		

}

_UIObject.prototype.closeWindow = function (f){
	$('##'+f).data("kendoWindow").close();
	_WINDOWS.pop();
}

_UIObject.prototype.restoreWindow = function (f){
	$('##'+f).data("kendoWindow").restore();
}

_UIObject.prototype.existsWindow = function (f) {
	if(jQuery.inArray(f, _WINDOWS) !== -1) {
		return true;
	} else {
		return false;
	}
}

_UIObject.prototype.doColor = function (){
	kendo.init($('.k-content'));
	$(".colorPicker").data("kendoColorPicker");
}

/***
 _UIObject.prototype.doCalendar = function (){
			$(".calendarRangePicker").html(function (i, html) {
				html.replace(/&nbsp;/g, '<br>');
				console.log('prueba')
			});
		}****/


_UIObject.prototype.doAlert = function(tlt,msg,color) {
	$("##_UIDialog").append("</br></br></br>");
	$("##_UIDialog").append(msg);
	$("##_UIDialog").append("</br></br></br></br></br>");
	$("##_UIDialog").show();
	$("##_UIDialog").kendoDialog({
		animation: {
			open: {
				effects: "slideIn:down",
				duration: 200

			}
		},
		visible: true,
	close: function(e) {
	$("##_UIDialog").html("");
	$("##_UIDialog").hide();
	},
		title : tlt,
		actions: [{
			text: "Ok",
			action: function(e){
				// e.sender is a reference to the dialog widget object
				// OK action was clicked
				// Returning false will prevent the closing of the dialog
				return true;
			},
			primary: true
		}]
	});

	try{ $("##_UIDialog").data("kendoDialog").open(); } catch(e) {}

	if (color!='') $(".k-dialog-titlebar").css('background',color);

} //end doAlert

function saveExpanded(id) {
	console.log(id);
	var treeview = $("##"+id).data("kendoTreeView");
	var expandedItemsIds = {};
/***
	treeview.select().find(".k-item").each(function () {
		var item = treeview.dataItem(this);
		if (item.expanded) {
			expandedItemsIds[item.id] = true;
		}
	});
***/
	//Cookies.set(id+'_expanded', kendo.stringify(expandedItemsIds));
}

function _tree_collapse(e){
	/***
	var id = this.element.context.id;
	var item = this.dataItem(e.node);
	var element = this.dataItem(e.node);
	var str_expanded = Cookies.get(id+'_expanded');
	var expanded = null;
	if (str_expanded) {
		expanded = JSON.parse(str_expanded);
	}
	if (expanded) {
		if (expanded[element.id]) {
			//expanded[element.id] = false;
		}
	}
	***/
}

function _tree_action(e) {
	console.log("select..", e.node);
	var url = $(e.node).attr('data-url');
	var target = $(e.node).attr('data-target');

	console.log(url);
	console.log(target);

	_SELECTED_ITEMS.push({id:e.node.id,value:$(e.node).attr('data-value')})

	if (url) {
		if (url != '') {
			if (url.search("javascript")!=-1) {
				eval(url);
			}
			else
			{
				if (target != '') {
					ptoken.open(url, target);
				}
			}
		}
	}

}

function _tree_action_binder(e) {

	var id = e.node.id;
	var item = this.dataItem(e.node);
	var url = item.HREF;
	var target = item.TARGET;
	console.log(url);
	console.log(target);

	_SELECTED_ITEMS.push({id:id,value:item.VALUE})

	saveExpanded(id,e.node);
	if (url) {
		if (url != '') {
			if (url.search("javascript")!=-1) {
				eval(url);
			}
			else
			{
				if (target != '') {
					ptoken.open(url, target);
				}
			}
		}
	}

}

function _tree_action_binder_single(item) {
	console.log(item);
	var url = item.HREF;
	var target = item.TARGET;
	console.log(url);
	console.log(target);

	if (url) {
		if (url != '') {
			if (url.search("javascript")!=-1) {
				eval(url);
			} else {
				if (target != '') {
					ptoken.open(url, target);
				}
			}
		}
	}

}

function _expand_to() {
	var data = this.items();
	var expanded = null;
/***
 	 console.log(this.select());
	if (this.select()) {
		var id = this.element.context.id;
		var str_expanded = Cookies.get(id + '_expanded');
		var expanded = null;
		if (str_expanded) {
			expanded = JSON.parse(str_expanded);
		}
	}
 ***/

	for (var i = 0; i < data.length; i++) {
		var dataitem = data[i];
		var element = this.dataItem(dataitem);
		if (element.level()<=_DEFAULT_LEVEL_) {
			this.expand(dataitem);
		}
		if (expanded) {
			if (expanded[element.id]) {
				this.expand(dataitem);
			}
		}

	}
}

 _UIObject.prototype.doToolTip = function(id,title,content,contentURL,w,h,position,duration,callout,showOn) {

	if (content =='') {
		if (contentURL == '') {
			tooltip = $("##cf_tip_"+id).kendoTooltip({}).data("kendoTooltip");
		} else {
			tooltip = $("##cf_tip_"+id).kendoTooltip(
				{
					'content': {
						url : contentURL
					 } ,
					'callout': (callout.localeCompare("false") ==0 ? 0 : 1),
					'width': w,
					'height': h,
					'showOn': showOn,
					'position': position,
					'iframe' : false,
					show: function() {
						this.refresh();
					},
					animation: {
						open: {
							effects: "zoom:in",
							duration: duration
						}
					}
				}
				).data("kendoTooltip");

		}
	} else {
		tooltip = $("##cf_tip_"+id).kendoTooltip(
				{
					'content': content,
					'callout': (callout.localeCompare("false") ==0 ? 0 : 1),
					'width': w,
					'height': h,
					'showOn': showOn,
					'position': position,
					'iframe' : false,
					animation: {
						open: {
							effects: "zoom:in",
							duration: duration
						}
					}
				}
		).data("kendoTooltip");
	}

}

_UIObject.prototype.doTooltipPositioning = function(h) {

	var dTT = $('div.k-tooltip:visible');
	dTT.animate({height:h},400,function(){

		var childPos = dTT.offset();
		var parentPos = dTT.parent().offset();

		var eWidth = dTT.width();
		var eHeight = dTT.height();

		var wWidth = $(window).width()
		var wHeight = $(window).height()

		var dWidth = $(document).width()
		var dHeight = $(document).height()

		vTop = parentPos.top;
		var vsum = vTop+eHeight;
		console.log('sum',vsum);

		if (vsum > wHeight) {
			vNewTop = wHeight - eHeight-40;
			childPos.top = vNewTop;
			parentPos.top = vNewTop;
			console.log('new top',childPos);
			//dTT.offset(childPos);
			dTT.parent().offset(parentPos);
		}
	});

}

_UIObject.prototype.doTabStrip = function(id,content){
	var ts = $("##tabstrip_"+id).kendoTabStrip({
		animation: {open: {effects: "fadeIn"}},
		contentUrls: content
	}).data('kendoTabStrip');

}

_UIObject.prototype.doMenu = function(id){
	var ts = $("##Menu_"+id).kendoMenu(
		{animation: { open: {
			effects: "zoomIn",
			duration: 100
			}
		}
		});
	$("##Menu_"+id).show();
}

_UIObject.prototype.doBreadCrumb = function(id,content){
	console.log("id",id);
	console.log(content);
	var ts = $("##BreadCrumb_"+id).kendoBreadcrumb({navigational: true, items:content});
}

_UIObject.prototype.doTree = function(id,checkboxes){
	_TREES.push(id);

	$("##_"+id).show();
	if (checkboxes == "No")
		$("##"+id).kendoTreeView();
	else {
		$("##"+id).kendoTreeView({checkboxes: {checkChildren: true}});
	}
	_tree_view = $("##"+id).data("kendoTreeView");
	if (_tree_view) {
		_tree_view.bind("select", _tree_action);
			//provision for subscribing on a clicking event on an already selected item
		$("##"+id).on("click", "li .k-state-selected", function(e) {
			node = $(this).closest("li")[0];
			console.log(node);
			_tree_action({ node: node });
		});
	}

}

_UIObject.prototype.doTreeBinder = function(id,serviceRoot,serviceMethod,checkboxes,serviceData) {
		console.log(serviceRoot);
		console.log(serviceMethod);
		console.log(serviceData);

		binder = new kendo.data.HierarchicalDataSource({
			transport: {
				read: {
					url: "#Client.root#/System/getJson.cfm?service="+serviceRoot+ "&method="+serviceMethod,
					dataType: "json",
					data: serviceData[0]
				}
			},
		schema: {
			model: {
					id: "VALUE",
					hasChildren: function(item) {
						return !item.LEAFNODE;
					}
				}
			}
		});

		console.log(binder);

		console.log('id',id);
		_TREES.push(id);

		if ($("##_prosis-tree-template").html())
			var _html = $("##_prosis-tree-template").html();
		else
			console.log('Please enable tree template by adding Template = yes on ScreenTop')

		if (checkboxes == "No")
		{
			$("##"+id).kendoTreeView({
				dataSource: binder,
				template: kendo.template(_html),
				dataBound: _expand_to
			});
		}
		else
		{
			$("##"+id).kendoTreeView({
				checkboxes: {
					checkChildren: true
				},
				dataSource: binder,
				template: kendo.template(_html),
				dataBound: _expand_to
			});

		}

		_tree_view = $("##"+id).data("kendoTreeView");
		if (_tree_view) {

			_tree_view.bind("select", _tree_action_binder);
			_tree_view.bind("collapse", _tree_collapse);

			//provision for subscribing on a clicking event on an already selected item
			$("##"+id).on("click", "li .k-state-selected", function(e) {
				node = $(this).closest("li")[0];
				dtree = $(this).closest("div .k-treeview")[0];
				var id = $(dtree).attr('id');
				_tree_view = $("##"+id).data("kendoTreeView");
				var item=_tree_view.dataItem(node);
				_tree_action_binder_single(item);
			});
		}
}

_UIObject.prototype.doOpenTree = function(id,node){
	_treeview = $('##'+id).data("kendoTreeView");
	var bar = _treeview.findByText(node);
	//_treeview.select(bar);
	console.log(bar);
	_treeview.select(bar);
/***
	data = _treeview.items();

	for (var i = 0; i < data.length; i++) {
		var dataitem = data[i];
		var element = _treeview.dataItem(dataitem);
		console.log(element);

	}
***/
}

_UIObject.prototype.doCalendarRange = function(id){

	vFormat = "#Replace(CLIENT.DateFormatShow,'mm','MM')#";	
	lb_start = $("##"+id+"_lbl_start").val();
	lb_end = $("##"+id+"_lbl_end").val();	
	date_start = $("##"+id+"_date_start").val();
	date_end = $("##"+id+"_date_end").val();	
	enabled = $("##"+id+"_enabled").val();
	onChange = $("##"+id+"_onchange").val();	
	$("##"+id+" _start").val(date_start);
	$("##"+id+"_end").val(date_end);
	console.log(date_start);
	console.log(kendo.parseDate(date_start,vFormat))
	
	$("##"+id).kendoDateRangePicker({
		culture: "en-NL",
		change: function(){
			var range = this.range();
			
			var vStart = kendo.toString(range.start, vFormat);
			var vEnd   = kendo.toString(range.end, vFormat);
			
			$("##"+id+"_start").val(vStart);
			$("##"+id+"_end").val(vEnd);
			
			if (onChange != '')
			{
				eval(onChange+"(range)")
			}			
		},
         "messages": {
             "startLabel": lb_start,
             "endLabel": lb_end
         },
		range: { start: kendo.parseDate(date_start,vFormat), end:  kendo.parseDate(date_end,vFormat)}
	}).data("kendoDatePicker");

	if (enabled == 'No') {
		var dateRangePicker =$("##"+id).data("kendoDatePicker");
		dateRangePicker.enable(false);
	}
	
	$(".k-textbox").css('border-color','silver');	
	$(".k-textbox").css('color','##000');	
	$(".k-textbox-container").css('width','110px');	
	
}
</script>

<div id="_ProsisUI" class="k-content"></div>
</cfoutput>

<cfif attributes.treeTemplate eq "Yes">
	<cfinclude template="UITreeBinderTemplate.cfm">
</cfif>

<script>
	_UIObject.prototype.escapeHtml = function (unsafe) {
		return unsafe
				.replace(/&/g, "&amp;")
				.replace(/</g, "&lt;")
				.replace(/>/g, "&gt;")
				.replace(/"/g, "&quot;")
				.replace(/'/g, "&#039;");
	}

	_UIObject.prototype.testme = function () {
		alert('test');
	}

	var ProsisUI = new _UIObject;

</script>




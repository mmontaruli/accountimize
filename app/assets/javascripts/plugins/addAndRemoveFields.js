function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  var tr = "tr";
  if ($('body').hasClass("estimates")) {
    tr = "tr.line_collection";
  }
  $(link).closest(tr).fadeOut(400);
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  $(link).closest("tr").before(content.replace(regexp, new_id));

  allowFormSelect();
}

function add_negotiate_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  var estimateLine = $(link).parents("tr.line_collection");

  // TODO not sure what the below line does...
  estimateLine.nextAll("tr.line_item, tr.add_lines, tr.total_line").eq(0).prevAll("tr.negotiate_line").eq(0).find("td.blank.accept input[type=checkbox] + label").hide();

  $(link).hide();
  $(link).prev(".thumbs-up").hide();

  estimateLine.find("td.collection_cell table.collection_table tbody").append(content.replace(regexp, new_id));

  allowFormSelect();
}
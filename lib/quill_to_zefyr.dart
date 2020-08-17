import 'package:quill_delta/quill_delta.dart';

Delta convertIterableToDelta(Iterable list) {
  try {
    var finalZefyrData = [];
    list.toList().forEach((quillNode) {
      var finalZefyrNode = {};
      print(quillNode);
      var quillInsertNode = quillNode["insert"];
      var quillAttributesNode = quillNode["attributes"];
      if (quillAttributesNode != null) {
        var finalZefyrAttributes = {};
        if (quillAttributesNode is Map) {
          quillAttributesNode.keys.forEach((attrKey) {
            if (["b", "i", "block", "heading", "a", "checkbox"]
                .contains(attrKey)) {
              finalZefyrAttributes[attrKey] = quillAttributesNode[attrKey];
            } else if (["background", "align"].contains(attrKey)) {
              // not sure how to implement
            } else {
              if (attrKey == "bold")
                finalZefyrAttributes["b"] = true;
              else if (attrKey == "italic")
                finalZefyrAttributes["i"] = true;
              else if (attrKey == "blockquote")
                finalZefyrAttributes["block"] = "quote";
              else if (attrKey == "code-block")
                finalZefyrAttributes["block"] = "code";
              else if (attrKey == "embed" &&
                  quillAttributesNode[attrKey]["type"] == "dots")
                finalZefyrAttributes["embed"] = {"type": "hr"};
              else if (attrKey == "header")
                finalZefyrAttributes["heading"] =
                    quillAttributesNode[attrKey] ?? 1;
              else if (attrKey == "link")
                finalZefyrAttributes["a"] =
                    quillAttributesNode[attrKey] ?? "n/a";
              else if (attrKey == "list" &&
                  quillAttributesNode[attrKey] == "bullet")
                finalZefyrAttributes["block"] = "ul";
              else if (attrKey == "list" &&
                  quillAttributesNode[attrKey] == "ordered")
                finalZefyrAttributes["block"] = "ol";
              else if (attrKey == "list" &&
                  quillAttributesNode[attrKey] == "checked")
                finalZefyrAttributes["checkbox"] = "checked";
              else if (attrKey == "list" &&
                  quillAttributesNode[attrKey] == "unchecked")
                finalZefyrAttributes["checkbox"] = "unchecked";
              else {
                print("ignoring " + attrKey);
              }
            }
          });
          if (finalZefyrAttributes.keys.length > 0)
            finalZefyrNode["attributes"] = finalZefyrAttributes;
        }
      }
      if (quillInsertNode != null) {
        if (quillInsertNode is Map && quillInsertNode.containsKey("image")) {
          var finalAttributes = {
            "embed": {"type": "image", "source": quillInsertNode["image"]}
          };
          finalZefyrNode["insert"] = String.fromCharCode(0x200b);
          finalZefyrNode["attributes"] = finalAttributes;
        } else {
          finalZefyrNode["insert"] = quillInsertNode;
        }
        finalZefyrData.add(finalZefyrNode);
      }
    });
    return Delta.fromJson(finalZefyrData);
  } catch (e) {
    throw e;
  }
}

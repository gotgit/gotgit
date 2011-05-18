// streamtty.js - a pty client for jstty
// Copyright 2008 Jack Christopher Kastorff
(function(){

var repeatString = function (str, rep) {
    var outstr = '';
    for (var i = 0; i < rep; i++) {
        outstr += str;
    }
    return outstr;
};

var makeTable = function (width, height) {
    var table = document.createElement("div");
    var arr = [];
    for (var j = 1; j <= height; j++) {
        var row = document.createElement("div");
        var arrrow = [];
        row.style.fontFamily = '"ProFont", "Luxi Mono", "Monaco", "Courier", "Courier new", monospace';
        row.style.margin = '0';
        row.style.padding = '0';
        row.style.wordSpacing = '0';
        row.style.height = '1.2em';
        for (var i = 1; i <= width; i++) {
            var charelem = document.createElement("pre");
            charelem.style.backgroundColor = '#000';
            charelem.style.color = '#FFF';
            charelem.style.display = 'inline';
            charelem.style.fontWeight = 'normal';
            charelem.style.textDecoration = 'none';
            charelem.style.letterSpacing = '0';
            charelem.style.margin = '0';
            charelem.style.padding = '0 0 0.2em 0';
            charelem.appendChild(document.createTextNode(" "));
            row.appendChild(charelem);
            arrrow.push(charelem);
        }
        table.appendChild(row);
        arr.push(arrrow);
    }
    return { "arr": arr, "elem": table };
};

var setTextChunk = function (tb, r, index, stx) {
    for (var i = 0; i < r.length; i++) {
        tb.arr[index][i+stx].firstChild.replaceData(0, 1, r.charAt(i));
    }
};

var setBoldChunk = function (tb, r, index, stx) {
    for (var i = 0; i < r.length; i++) {
        tb.arr[index][i+stx].style.fontWeight = r.charAt(i) == 0 ? 'normal' : 'bold';
    }
};

var setUnderlineChunk = function (tb, r, index, stx) {
    for (var i = 0; i < r.length; i++) {
        tb.arr[index][i+stx].style.textDecoration = r.charAt(i) == 0 ? 'none' : 'underline';
    }
};

var clut = { 0: "#000", 1: "#D00", 2: "#0D0", 3: "#DD0", 4: "#00D", 5: "#D0D", 6: "#0DD", 7: "#DDD" };

var setFcolorChunk = function (tb, r, index, stx) {
    for (var i = 0; i < r.length; i++) {
        tb.arr[index][i+stx].style.color = clut[r.charAt(i)];
    }
};

var t = 0;
var setBcolorChunk = function (tb, r, index, stx) {
    for (var i = 0; i < r.length; i++) {
        tb.arr[index][i+stx].style.backgroundColor = clut[r.charAt(i)];
    }
};

var loadIFrame = function (tb, rowcaches, fr, width, height) {
    var d = uncompressIFrameBlock(fr.d, width);
    for (var i = 0; i < d.length; i++) {
        setTextChunk(tb, d[i], i, 0);
        rowcaches.d[i] = d[i];
    }
    var B = uncompressIFrameBlock(fr.B, width);
    for (var i = 0; i < B.length; i++) {
        setBoldChunk(tb, B[i], i, 0);
        rowcaches.B[i] = B[i];
    }
    var U = uncompressIFrameBlock(fr.U, width);
    for (var i = 0; i < U.length; i++) {
        setUnderlineChunk(tb, U[i], i, 0);
        rowcaches.U[i] = U[i];
    }
    var f = uncompressIFrameBlock(fr.f, width);
    for (var i = 0; i < f.length; i++) {
        setFcolorChunk(tb, f[i], i, 0);
        rowcaches.f[i] = f[i];
    }
    var b = uncompressIFrameBlock(fr.b, width);
    for (var i = 0; i < b.length; i++) {
        setBcolorChunk(tb, b[i], i, 0);
        rowcaches.b[i] = b[i];
    }
};

var uncompressIFrameBlock = function (d,width) {
    var uncomp = [];
    var last = null;
    for (var i = 0; i < d.length; i++) {
        var uncomprow = null;
        if ( typeof d[i] == 'array' || typeof d[i] == 'object' ) {
            if ( d[i][0] == "r" ) {
                uncomprow = d[i][1];
            } else if ( d[i][0] == "a" ) {
                uncomprow = repeatString(d[i][1], width);
            } else {
                throw new Error ("bad iframe data: subarray is not valid");
            }
        } else if ( typeof d[i] == 'string' && d[i] == 'd' ) {
            uncomprow = last;
        } else {
            throw new Error ("bad iframe data: unknown " + (typeof d[i]) + " in array");
        }
        uncomp.push(uncomprow);
        last = uncomprow;
    }
    return uncomp;
};

var loadPFrame = function (table, rowcaches, fr, width, height) {
    if ( fr.d ) {
        diffPushGeneric(table, annotatedPFrameBlock(fr.d, width), rowcaches.d, setTextChunk);
    }
    if ( fr.B )  {
        diffPushGeneric(table, annotatedPFrameBlock(fr.B, width), rowcaches.B, setBoldChunk);
    }
    if ( fr.U ) {
        diffPushGeneric(table, annotatedPFrameBlock(fr.U, width), rowcaches.U, setUnderlineChunk);
    }
    if ( fr.f ) {
        diffPushGeneric(table, annotatedPFrameBlock(fr.f, width), rowcaches.f, setFcolorChunk);
    }
    if ( fr.b ) {
        diffPushGeneric(table, annotatedPFrameBlock(fr.b, width), rowcaches.b, setBcolorChunk);
    }
};

var diffPushGeneric = function (table, d, rowcache, set) {
    // convert everything to line operations
    for (var i = 0; i < d.length; i++) {
        var e = d[i];
        if ( e[0] == "cp" ) {
            set(table, rowcache[e[1]], e[2], 0);
            rowcache[e[2]] = rowcache[e[1]];
        } else if ( e[0] == 'char' ) {
            var r = e[1];
            var v = rowcache[r];
            var da = v.slice(0, e[2]) + e[3] + v.slice(e[2]+1);
            set(table, e[3], e[1], e[2]);
            rowcache[r] = da;
        } else if ( e[0] == 'chunk' ) {
            var r = e[1];
            var v = rowcache[r];
            var da = v.slice(0, e[2]) + e[4] + v.slice(e[3]+1);
            set(table, e[4], e[1], e[2]);
            rowcache[r] = da;
        } else if ( e[0] == 'line' ) {
            set(table, e[2], e[1], 0);
            rowcache[e[1]] = e[2];
        } else {
            throw new Error ("unknown p-frame item type " + e[0] + ", len " + e.length);
        }
    }
};

var annotatedPFrameBlock = function (frame, width) {
    var ann = [];
    for (var i = 0; i < frame.length; i++) {
        var e = frame[i];
        if ( e[0] == 'cp' ) {
            ann.push(e);
        } else if ( e.length == 2 ) {
            // raw line
            if ( typeof e[1] == 'string' ) {
                ann.push(['line', e[0], e[1]]);
            } else if ( e[1][0] == "a" ) {
                ann.push(['line', e[0], repeatString(e[1][1], width)]);
            } else {
                throw new Error ("p-frame corrupted: invalid 2-len");
            }
        } else if ( e.length == 3 ) {
            // char
            ann.push(['char', e[0], e[1], e[2]]);
        } else if ( e.length == 4 ) {
            // chunk
            if ( typeof e[3] == 'string' ) {
                ann.push(['chunk', e[0], e[1], e[2], e[3]]);
            } else if ( e[3][0] == 'a' ) {
                ann.push(['chunk', e[0], e[1], e[2], repeatString(e[3][1], e[2]-e[1]+1)]);
            } else {
                throw new Error ("p-frame corrupted: invalid 4-len");
            }
        } else {
            throw new Error ("p-frame corrupted: no such thing as a " + e.length + "-len");
        }
    }
    return ann;
};

var handleCursor = function (table, bgcache, curpos, dx, dy) {
    if ( typeof dx == 'number' || typeof dy == 'number' ) {
        // make sure the old cursor position has been overwritten
        setBcolorChunk(table, bgcache[curpos[1]-1].charAt(curpos[0]-1), curpos[1]-1, curpos[0]-1);
        if ( typeof dx == 'number' ) {
            curpos[0] = dx;
        }
        if ( typeof dy == 'number' ) {
            curpos[1] = dy;
        }
    }

    // draw the cursor
    table.arr[curpos[1]-1][curpos[0]-1].style.backgroundColor = '#FFF';
};

var makeCache = function (ch, wid, hei) {
    var c = [];
    for (var y = 0; y < hei; y++) {
        c.push( repeatString(ch, wid) );
    }
    return c;
};

var newSendBuffer = function (h) {
    if ( ! h.activeRequest && h.sendBuffer.length > 0 ) {
        if ( h.timer ) clearTimeout(h.timer);
        request(h, "user input", { keys: h.sendBuffer } );
        h.sendBuffer = '';
    }
};

var request = function (h, cmd, args) {
    if ( h.activeRequest ) return;
    var url = '/api?';
    args['type'] = cmd;
    if ( h.id ) args['id'] = h.id;
    var urlargs = [];
    for (var k in args) {
        urlargs.push( encodeURIComponent(k) + '=' + encodeURIComponent(args[k]) );
    }
    url += urlargs.join("&");

    h.activeRequest = true;
    var req = new XMLHttpRequest();
    req.open("GET", url, true);
    req.onreadystatechange = function () {
        if ( req.readyState == 4 && req.status == 200 ) {
            var data = eval('(' + req.responseText + ')');
            if ( typeof data == "undefined" ) {
                alert("err: undefined");
                h.activeRequest = false;
                req = null;
                return;
            }
            if ( data.ok ) {
                if ( data.id ) h.id = data.id;
                if ( data.pframe ) {
                    loadPFrame(h.table, h.rowcaches, data.pframe, h.width, h.height);
                    if ( data.pframe.x && data.pframe.y ) {
                        handleCursor(h.table, h.rowcaches.b, h.curpos, data.pframe.x, data.pframe.y);
                    }
                }
                if ( data.iframe ) {
                    loadIFrame(h.table, h.rowcaches, data.iframe, h.width, h.height);
                    handleCursor(h.table, h.rowcaches.b, h.curpos, data.iframe.x, data.iframe.y);
                }
                h.timer = setTimeout( function () { request(h, "pframe", { }); }, h.timerlen.current );
                h.timerlen.current *= h.timerlen.step;
                if ( h.timerlen.current > h.timerlen.max ) {
                    h.timerlen.current = h.timerlen.max;
                }
                h.activeRequest = false;
                newSendBuffer(h);
            } else {
                h.activeRequest = false;
                alert("err: " + data.error);
            }
            req = null;
            return;
        } else if ( req.readyState == 4 && req.status != 200 ) {
            alert("err: response code " + req.status);
            h.activeRequest = false;
            req = null;
            return;
        }
    };
    req.send(null);
};

var keyPressHandler = function (h, e) {
    var str = String.fromCharCode(e.charCode);
    h.sendBuffer += str;
    h.timerlen.current = h.timerlen.min;
    e.stopPropagation();
    e.preventDefault();
    newSendBuffer(h);
    return false;
};

startStreamTTY = function (elem) {
    while ( elem.firstChild ) {
        elem.removeChild( elem.firstChild );
    }
    
    var width = 80;
    var height = 24;

    var table = makeTable(width, height);
    elem.appendChild(table.elem);

    var holder = {
        'width': width,
        'height': height,
        'table': table,
        'rowcaches': {
            'd': makeCache(" ", width, height),
            'f': makeCache("7", width, height),
            'b': makeCache("0", width, height),
            'B': makeCache("0", width, height),
            'U': makeCache("0", width, height)
        },
        'curpos': [1,1],
        'sendBuffer': '',
        'timerlen': {
            'max': 15000,
            'current': 100,
            'min': 100,
            'step': 1.05
        },
        'activeRequest': false,
      };

    document.body.addEventListener( "keypress", function (e) { return keyPressHandler(holder, e); }, true );

    request(holder, "create session", {});
};

}());

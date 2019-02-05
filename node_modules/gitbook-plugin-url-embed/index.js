var _ = require('lodash');

module.exports = {
  
  blocks: {
    urlembed: {
      process: function(blk) {

        url = blk.body.trim()
        if (this.output.name === 'website') {          
          return '<iframe src="' + url + '" style="width: 100%; height: 600px; border: 0px none;"></iframe>';
        }
        else {
          urlArr = _.split(url, "/")          
          imgName = urlArr[urlArr.length-1]          
          return '<img src="../assets/' + imgName + '.png" alt="'+ imgName +'">'
        }

        return "<div>html</div>"
      }
    }
  }

};
/** @jsx React.DOM */

var Binder = React.createClass({
  getInitialState: function () {
    return JSON.parse(this.props.presenter);
  },

  // handleCommentSubmit: function ( formData, action ) {
  //   $.ajax({
  //     data: formData,
  //     url: action,
  //     type: "POST",
  //     dataType: "json",
  //     success: function ( data ) {
  //       this.setState({ comments: data });
  //     }.bind(this)
  //   });
  // },

  render: function () {
    return (
      <CardList cards={ this.state.cards } img_host={ this.state.img_host } />
    );
  }
});
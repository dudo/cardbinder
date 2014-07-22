/** @jsx React.DOM */

var Card = React.createClass({
  render: function () {
    return (<li className={'sleeve ' + this.props.layout}>
              <div className='card' data-colors={ this.props.colors } data-types={ this.props.types }>
                <div className='front'>
                  <img src={this.props.img_host + '/' + this.props.set + '/' + this.props.name + '.jpg'} alt={this.props.name} />
                </div>
                <div className='back'>
                  <img src='https://cardbinder.s3.amazonaws.com/magic/back.jpg' />
                </div>
              </div>
            </li>)
  }
});

var CardList = React.createClass({
  render: function () {
    var cardNodes = this.props.cards.map(function ( card ) {
      return <Card colors={ card.manaCost.match(/[a-zA-Z]+/g) || [] }
                   types={ card.types || [] }
                   // key={ card._id }
                   set={ card.set_name.toLowerCase() }
                   name={ card.imageName }
                   layout={ card.layout }
                   img_host= 'http://mtgimage.com/setname' />
    });

    return (
      <ul className="binder">
        { cardNodes }
      </ul>
    )
  }
});
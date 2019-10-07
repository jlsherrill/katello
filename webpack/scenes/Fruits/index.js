import { withRouter } from 'react-router-dom';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import * as fruitActions from './FruitActions';
import FruitPage from './FruitPage';

import reducer from './FruitReducer';
export const fruits = reducer;

// How do we get the information from the Redux global store and into our component?
// This mapStateToProps will take the Redux state and use parts of it as our props in the local FruitPage component.
// This is filled in, the keys will be props that you can use in the compoennt and the values are from the Redux store.
// You will need to set up your reducer to properly set the state for this to work.
const mapStateToProps = state => ({
  //loading: state.katello.fruits.loading,
  results: state.katello.fruits.results,
  //errors: state.katello.fruits.errors,
});

const actions = {
  ...fruitActions,
};

// This is allowing the Redux actions to be used in the component
const mapDispatchToProps = dispatch => bindActionCreators(actions, dispatch);

// This is connecting the component to the Redux store and passing in the functions
// we set up above. It also is connecting the component to the router. Then, exporting
// it to be imported elsewhere. You will need to uncomment the following line when ready to connect
// the component to Redux
//
export default connect(mapStateToProps, mapDispatchToProps)(withRouter(FruitPage));




// Export basic page (no redux yet)
//export default withRouter(FruitPage);
import {
  FRUIT_SUCCESS
} from "./FruitConstants";
import Immutable from 'seamless-immutable';
const initialState = Immutable({});

import { propsToCamelCase } from 'foremanReact/common/helpers';

//asdfkdjfk

// setting a default state
const defaultState = {
  loading: false,
  results: [],
};

// Add Redux reducers here
export default (state = initialState, action) => {
  switch (action.type) {
    case FRUIT_SUCCESS: {
      const {
        results, page, perPage, subtotal,
      } = propsToCamelCase(action.response);
      console.log(results);
      console.log(action.response);
      return state.merge({
        results
      });
    }
    default: {
      return state;
    }

  }
}

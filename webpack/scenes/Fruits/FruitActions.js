// Put redux actions here
import api, { orgId } from '../../services/api';
import {
    FRUIT_SUCCESS
} from "./FruitConstants";

export const fetchFruits = () => async (dispatch) => {

    const params = {};
    const { data } = await api.get('/fruits', {}, params);
    return dispatch({
        type: FRUIT_SUCCESS,
        response: data,
    })

}

export default fetchFruits;
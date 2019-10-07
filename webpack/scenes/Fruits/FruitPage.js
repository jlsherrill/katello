// Edit this page to show the fruits table
import React, { Component } from 'react';
import { Table as ForemanTable } from 'foremanReact/components/common/table';
import { columns } from './FruitTableSchema';

class FruitPage extends Component {
  // eslint-disable-next-line no-useless-constructor
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    this.props.fetchFruits();
  }

  render() {
    return (
        <div>
        <p>blahblah</p>
      <ForemanTable
        rows={this.props.results}
        columns={columns}
      />
    </div>
    );
  }
}

export default FruitPage;
FruitPage.defaultProps = {results: []};
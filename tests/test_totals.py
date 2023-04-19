import duckdb
import pandas as pd
import pytest
from deepdiff import DeepDiff

def query(sql):
    con = duckdb.connect('data/db.duckdb')
    cur = con.execute(sql)

    columns = [col[0] for col in cur.description]

    result = []
    for row in cur.fetchall():
        result.append(dict(zip(columns, row)))

    con.close()
    
    return result
    
def read(path):
    result = pd.read_csv(path).to_dict('records')
    return result

def test_totals():
    expected = read('tests/data/test_totals_expected.csv')
    
    sql = """select ano_particao as ANO, round(sum(vr_empenhado), 2) as VL_EMP
             from ft_despesa 
             where ano_particao between 2002 and 2022 
             group by ano_particao
             order by ano_particao
           """
    result = query(sql)

    diff = DeepDiff(expected, result, verbose_level=2)
    
    if diff:
        pytest.fail(diff.pretty())

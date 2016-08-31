<?php
/**
 * Created by PhpStorm.
 * User: Fabiano
 * Date: 26/07/2016
 * Time: 22:00
 */
namespace GPLAC;
class EnemDAO
{
    private $con;
    private $obj;
    private $lista;
    /**
     * EnemDAO constructor
     */
    public function __construct()
    {
        $this->con = Conexao::getInstance()->getConexao();
    }
    function salvar(Enem $obj)
    {
        $query = sprintf("INSERT INTO enem (codigo, dataprevista, rota, ordem, destinatario, logradouro, bairro, cidade, uf, sabatina, provaespecial) VALUES ('%s', '%s', '%s', %d, '%s', '%s', '%s', '%s', '%s', '%s', '%s')",
            mysqli_real_escape_string($this->con, $obj->getCodigo()),
            mysqli_real_escape_string($this->con, $obj->getDataprevista()),
            mysqli_real_escape_string($this->con, $obj->getRota()),
            mysqli_real_escape_string($this->con, $obj->getOrdem()),
            mysqli_real_escape_string($this->con, $obj->getDestinatario()),
            mysqli_real_escape_string($this->con, $obj->getLogradouro()),
            mysqli_real_escape_string($this->con, $obj->getBairro()),
            mysqli_real_escape_string($this->con, $obj->getCidade()),
            mysqli_real_escape_string($this->con, $obj->getUf()),
            mysqli_real_escape_string($this->con, $obj->getSabatina()),
            mysqli_real_escape_string($this->con, $obj->getProvaespecial())
        );
        if(!mysqli_query($this->con, $query)) {
            die('[ERRO]: Class('.get_class($obj).') | Metodo(Cadastrar) | Erro('.mysqli_error($this->con).')');
        }
        return mysqli_insert_id($this->con);
    }

    function mudarStatus($codigo)
    {
        $query = sprintf("UPDATE interior SET status = 'TRIADO' WHERE codigo = '%s'",
            mysqli_real_escape_string($this->con, $codigo)

        );
        if(!mysqli_query($this->con, $query)){
            die('[ERRO]: Class(Enem) | Metodo(mudarStatus) | Erro('.mysqli_error($this->con).')');
        }
    }

    function buscarCodigo(Enem $enem)
    {
        $codigo = $enem->getCodigo();
        $query = sprintf("SELECT * FROM interior WHERE codigo = '%s'",
            mysqli_real_escape_string($this->con, $codigo)
        );
        if(!mysqli_query($this->con, $query)) {
            die('[ERRO]: Class('.get_class($enem).') | Metodo(buscarCodigo) | Erro('.mysqli_error($this->con).')');
        }
        $result = mysqli_query($this->con, $query);
        while ($row = mysqli_fetch_assoc($result)){
            $this->obj = $row;
        }
        self::mudarStatus($codigo);
        return $this->obj;

    }

    function contarResto()
    {
        $query = sprintf("SELECT * FROM interior WHERE status = 'PENDENTE'");
        if(!mysqli_query($this->con, $query)) {
            die('[ERRO]: Class(Enem) | Metodo(contarResto) | Erro('.mysqli_error($this->con).')');
        }
        $result = mysqli_query($this->con, $query);

        return $result->num_rows;
    }

    function contarTriados()
    {
        $query = sprintf("SELECT * FROM interior WHERE status = 'TRIADO'");
        if(!mysqli_query($this->con, $query)) {
            die('[ERRO]: Class(Enem) | Metodo(contarTriados) | Erro('.mysqli_error($this->con).')');
        }
        $result = mysqli_query($this->con, $query);

        return $result->num_rows;
    }

    function gerarPainel($data)
    {
        $diadaprova = "";
        if($data == '2016-11-05'){
            $diadaprova = 'sabado';
        }else if($data == '2016-11-06'){
            $diadaprova = 'domingo';
        }

        
        $query = sprintf("SELECT * FROM $diadaprova");

        $result = mysqli_query($this->con, $query);
        while ($row = mysqli_fetch_assoc($result)) {

            $sql = sprintf("select count(*) AS qtde from interior where rota = '%s'  AND status = 'TRIADO' AND dataprevista = '%s'",
                mysqli_real_escape_string($this->con, $row['rota']),
                mysqli_real_escape_string($this->con, $data)
            );
            $re = mysqli_query($this->con, $sql);
            while ($linha = mysqli_fetch_assoc($re)){
                $qnt = $linha['qtde'];
            }
            $row['conferidos'] = $qnt;
            $rotas[] = $row;
        }

        return $rotas;
    }
}
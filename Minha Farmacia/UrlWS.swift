//
//  Url.swift
//  Farmácia
//
//  Created by Kleiton Batista on 18/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class UrlWS: NSObject {
    
//    private let host = "minhafarmacia-env.us-west-2.elasticbeanstalk.com"
//    private let porta = "80"
    private let host = "172.16.2.134"
    private let porta = "8080/WebService"
    private let rota = "/cliente/"
    private let rotaMedicamento = "/medicamento/"
    private let rotaReceita = "/receita/"
    
    func urlAtualizarSenhaUsuario(email:String, comNovaSenha senha:String)->String{
        return "http://\(host):\(porta)\(rota)atualizar-senha/\(email)-\(senha)"
    }
    func urlAtualizarNomeUsuario(email:String, comNovoNome nome:String) -> String{
        
        return "http://\(host):\(porta)\(rota)atualizar-nome/\(email)-\(nome)"
    }
    /**
        url para atualizar dados do usuario
     
     */
    func urlInsereMedicamentoUsuario(email: String) -> String{
        
            return "http://\(host):\(porta)\(rotaMedicamento)atualizar/\(email)"
    }
    func urlInsereReceitaUsuario(email:String) ->String{
        return "http://\(host):\(porta)\(rotaReceita)atualizar/\(email)"
    }
    /**
        http://localhost:8080/WebService/medicamento/busca-medicamento/user-email/kleiton@gmail.com
     */
    func urlBuscaMedicamentoUsuario(email: String) -> String{
        return "http://\(host):\(porta)\(rotaMedicamento)busca-medicamento/email-user/\(email)"
    }
    
    /**
        //"http://192.168.0.12:8080/WebService/cliente/login/\(email)-\(senha)
     */
    func urlRealizaLogin(email: String, senha: String) -> String{
        return "http://\(host):\(porta)\(rota)login/\(email)-\(senha)"
    }
    
    /**
        "http://localhost:8080/WebService/cliente/recupera-senha/\(emailText.text!)"
     */
    func urlRecuperarSenha(email: String) -> String{
        return "http://\(host):\(porta)\(rota)recupera-senha/\(email)"
    }
    
    /**
        minhafarmacia-env.us-west-2.elasticbeanstalk.com:80/cliente/consulta-email/kleiton.a.batista@gmail.com
        http://192.168.0.12:8080/WebService/cliente/consulta-email/\(email)
     */
    func urlConsultaDisponibilidadeEmail(email: String) ->String{
        return "http://\(host):\(porta)\(rota)consulta-email/\(email)"
    }
    /**
     "http://192.168.0.12:8080/WebService/cliente/inserir"
     */
    func urlCadastrarUsuario()->String{
        return "http://\(host):\(porta)\(rota)inserir"
    }
    func urlAlterarFotoPerfil()->String{
        return "http://\(host):\(porta)\(rota)atualizar-foto"
    }
}

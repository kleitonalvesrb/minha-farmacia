//
//  Url.swift
//  Farmácia
//
//  Created by Kleiton Batista on 18/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class UrlWS: NSObject {
    
    private let host = "localhost"
    private let porta = "8080"
    private let rota = "/WebService/cliente/"
 
    
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
}

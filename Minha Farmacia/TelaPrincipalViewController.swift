//
//  TelaPrincipalViewController.swift
//  Farmácia
//
//  Created by Kleiton Batista on 05/08/16.
//  Copyright © 2016 Kleiton Batista. All rights reserved.
//

import UIKit

class TelaPrincipalViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var btnMedicamento: UIBarButtonItem!
    @IBOutlet weak var ImageUsuario: UIImageView!
    @IBOutlet weak var tableView: UITableView!
 //667
    @IBOutlet weak var viewTrocarSenha: UIView!
    @IBOutlet weak var textSenhaAntiga: UITextField!
    @IBOutlet weak var textNovaSenha: UITextField!
    @IBOutlet weak var btnTrocarSenha: UIButton!
    @IBOutlet weak var btnCancelar: UIButton!
    var user:Usuario!
    var titulos = [String]()
    var conteudo = [String]()
    var senha:String = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configuraLayoutViewTrocarSenha()
        
        if self.view.frame.height > 665{
            scroll.scrollEnabled = false
        }
        user = Usuario.sharedInstance
        ImageUsuario.image = user.foto
        
        populaArrayTitulos()
        populaConteudo()
        
//        let tapFoto: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: Selector("trocaFoto"))
//        ImageUsuario.addGestureRecognizer(tapFoto)
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("imageTapped:"))
        ImageUsuario.userInteractionEnabled = true
        ImageUsuario.addGestureRecognizer(tapGestureRecognizer)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TesteViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
      
    }
    func imageTapped(img: AnyObject)
    {
        alterarFotoPerfil()
    }
    func dismissKeyboard() ->Void{
        print("sai daki teclado")
        self.view.endEditing(true)
    }
    /**
        Da as alterantivas para trocar a foto do perfil do usuario, tirar nova foto, escolher da galeria
        e retirar foto
     
     */
    func alterarFotoPerfil(){
        let alertaEscolha = UIAlertController(title: "Trocar foto", message: nil, preferredStyle: .ActionSheet)
        let camera = UIAlertAction(title: "Câmera", style: .Default) { (_) in
            self.definirFoto(true)
        }
        let galeria = UIAlertAction(title: "Galeria", style: .Default) { (_) in
            self.definirFoto(false)
        }
        let remover = UIAlertAction(title: "Remover Foto", style: .Destructive) { (_) in
            self.ImageUsuario.image = UIImage(named: "homem.png")
        }
        let cancelar = UIAlertAction(title: "Cancelar", style: .Cancel) { (_) in
            print("cancelar")
            
        }
        alertaEscolha.addAction(camera)
        alertaEscolha.addAction(galeria)
        alertaEscolha.addAction(remover)
        alertaEscolha.addAction(cancelar)
        self.presentViewController(alertaEscolha, animated: true, completion: nil)
    }
    /**
     #A foram de definir a foto depende da escolha#
     Irá definir a imagem correta da maneira que o usuario escolheu
     **/
    func definirFoto(camera : Bool){
        let img = UIImagePickerController()
        img.delegate = self
        /*Define a forma que a foto será selecionada, camera ou galeria*/
        if camera {
            img.sourceType = UIImagePickerControllerSourceType.Camera
        }else{
            img.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        
        img.allowsEditing = false
        self.presentViewController(img, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.dismissViewControllerAnimated(true, completion: nil)
        ImageUsuario.image = image
    }
    
    
    func configuraLayoutViewTrocarSenha(){
        viewTrocarSenha.hidden = true
        viewTrocarSenha.layer.masksToBounds = true
        viewTrocarSenha.layer.cornerRadius = 5
        
        btnCancelar.layer.masksToBounds = true
        btnCancelar.layer.cornerRadius = 5
        btnTrocarSenha.layer.masksToBounds = true
        btnTrocarSenha.layer.cornerRadius = 5
    }

    func populaArrayTitulos(){
        titulos.append("Nome")
        titulos.append("Email")
        titulos.append("Senha")
        titulos.append("Sexo")
        titulos.append("Idade")
        titulos.append("Facebook")
    }
    func populaConteudo(){
     conteudo.append(user.nome)
     conteudo.append(user.email)
     conteudo.append("******")
     conteudo.append(user.sexo)
     conteudo.append("idade")
     conteudo.append("facebook")
    }
    
    @IBAction func cancelar(sender: AnyObject) {
        print("cancelar")
        self.tableView.reloadData()
        viewTrocarSenha.hidden = true
        self.tableView.userInteractionEnabled = true

    }
    @IBAction func trocarSenha(sender: AnyObject) {
        trocarSenhaUsuario(senhaAtual: textSenhaAntiga.text!, novaSenha: textNovaSenha.text!)
       dismissKeyboard()
        print("Trocar a senha")
        self.tableView.userInteractionEnabled = true
        self.tableView.reloadData()
    }
    func trocarSenhaUsuario(senhaAtual senhaAtual:String,  novaSenha:String) -> Void{
        let util = Util()
        
        if !util.isVazio(senhaAtual.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) && //
            !util.isVazio(novaSenha.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())){ //verifica se os campos estao vazios
            // os campos estão preenchidos
            if senhaAtual == user.senha{ // verifica se foi informado a senha atual
                if novaSenha != user.senha{ // verifica se a nova senha é igual a senha atual
                    if novaSenha.characters.count >= 6 { // verifica se a senha possui mais de 6 letras
                        geraAlerta("Ok", mensagem: "Sua senha foi alterada com sucesso!")// msg de sucesso
                        dismissKeyboard()
                        viewTrocarSenha.hidden = true
                    }else{
                        geraAlerta("Ops!", mensagem: "A senha deve ter no mínimo 6 caracters") // acusa erro caso a senha tenha menos de 6 carcter
                    }
                }else{
                    geraAlerta("Ops!", mensagem: "Para trocar a senha a nova senha deve ser diferente da senha atual") // acusa erro caso a nova senha seja igual a senha atual
                }
            }else{
                geraAlerta("Ops", mensagem: "A senha atual deve ser informada") // acusa erro caso a senha atual nao tenha sido informada
            }
        }else{
            geraAlerta("Ops!", mensagem: "Todos os campos deve ser preenchidos") // acusa erro casa no tenha preenchido todos os campos
        }
        
    }
    override func viewDidAppear(animated: Bool) {
        let navigationBarAppearace = UINavigationBar.appearance()
        
        navigationBarAppearace.translucent = false
        
        
        
        navigationBarAppearace.barTintColor = UIColor(red: 53.0/255.0, green: 168.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationItem.hidesBackButton = true
        
        self.navigationItem.title = "Perfil"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1        //return frutaAlfabetica.keys.count
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titulos.count
        
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PerfilTableViewCell
        //cell.textLabel?.text = self.items[indexPath.section][indexPath.row]
        cell.labelConteudo.text = conteudo[indexPath.row]
        cell.labelTitulo.text = titulos[indexPath.row]
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if titulos[indexPath.row].lowercaseString == "Nome".lowercaseString{
            alteraNomeUsuario(indexPath.row)
        }else if titulos[indexPath.row].lowercaseString == "Sexo".lowercaseString{
            print("alterar Sexo")
        }
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        if titulos[indexPath.row].lowercaseString == "Nome".lowercaseString{
            let alterar = UITableViewRowAction(style: .Normal, title: "Alterar") { action, index in
                self.alteraNomeUsuario(indexPath.row)
            }
            alterar.backgroundColor = UIColor.blueColor()
            return [alterar]
        
        }else if titulos[indexPath.row].lowercaseString == "Senha".lowercaseString{
            let alterarSenha = UITableViewRowAction(style: .Normal,title: "Alterar Senha"){action, index in
//                self.alteraSenhaUsuario(indexPath.row)
                self.tableView.userInteractionEnabled = false
                self.viewTrocarSenha.hidden = false
            }
            alterarSenha.backgroundColor = UIColor.redColor()
            return [alterarSenha]
            
        }
        
        
        //        let favorite = UITableViewRowAction(style: .Normal, title: "Favorite") { action, index in
//            print("favorite button tapped")
//        }
//        favorite.backgroundColor = UIColor.orangeColor()
//        
//        let share = UITableViewRowAction(style: .Normal, title: "Share") { action, index in
//            print("share button tapped")
//        }
//        share.backgroundColor = UIColor.lightGrayColor()
        
        //return [share, favorite, more]
        return nil
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if titulos[indexPath.row].lowercaseString == "Nome".lowercaseString{
            return true
        }else if titulos[indexPath.row].lowercaseString == "Senha".lowercaseString{
            return true
        }
        // the cells you would like the actions to appear needs to be editable
        return false
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Entrou nesse método estranho")
        self.tableView.reloadData()
        // you need to implement this method too or you can't swipe to display the actions
    }
    /**
     Método responsavel por gerar uma caixa de dialogo com o usuário afim de trocar a sua senha,
     atualiza a tabela e devera alterar os dados no servidor
     */
    func alteraSenhaUsuario(index:Int){
        let alerta = UIAlertController(title: "Alterar Senha", message: nil, preferredStyle: .Alert)
        let trocarSenha = UIAlertAction(title: "Alterar", style: .Default, handler: { (_) in
            let senhaAtual = alerta.textFields![0] as UITextField
            let novaSenha = alerta.textFields![1] as UITextField
            senhaAtual.tag =  1
            novaSenha.tag = 2
            
            if senhaAtual.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "" &&
               novaSenha.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                if senhaAtual.text! == self.user.senha{
                    if senhaAtual.text! != novaSenha.text{
                        self.conteudo[index] = novaSenha.text!
                        self.tableView.reloadData()
                    }else{
                        self.geraAlerta("Ops!", mensagem: "Você não pode utilizar a mesma senha")
                    }
                }else{
                    self.geraAlerta("Ops!", mensagem: "Você deve informar a senha atual!")
                }
            }else{
                self.geraAlerta("Ops!", mensagem: "Todos os campos devem ser preenchidos")
            }
    })
    alerta.addTextFieldWithConfigurationHandler { (texteField) in
        if texteField.tag == 1{
           texteField.placeholder = "Senha Atual"
        }else if texteField.tag == 2{
            texteField.placeholder = "Nova Senha"
        }
        texteField.secureTextEntry = true
        texteField.keyboardType = .Default
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Destructive) { (_) in }
        alerta.addAction(trocarSenha)
        alerta.addAction(cancelAction)
        self.presentViewController(alerta, animated: true, completion: nil)
    }
}
    
   
        
    /**
        Método responsavel por gerar uma caixa de dialogo com o usuário afim de trocar o nome,
     atualiza a tabela e devera alterar os dados no servidor
     */
    func alteraNomeUsuario(index:Int){
        let alerta = UIAlertController(title: "Informe o novo nome", message: nil, preferredStyle: .Alert)
        let trocaNome = UIAlertAction(title: "Salvar", style: .Default, handler: { (_) in
            let nome = alerta.textFields![0] as UITextField
            if nome.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != ""{
                self.conteudo[index] = nome.text!
                self.tableView.reloadData()
            }else{
                print("nao pode trocar")
            }
            
        })
        
        
        alerta.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Nome"
            textField.keyboardType = .Default
        }
        let cancelAction = UIAlertAction(title: "Cancelar", style: .Destructive) { (_) in }
        alerta.addAction(trocaNome)
        alerta.addAction(cancelAction)
        
        self.presentViewController(alerta, animated: true, completion: nil)
        

    }
    func geraAlerta(title: String, mensagem: String){
        let alerta = UIAlertController(title: title, message: mensagem, preferredStyle: .Alert)
        alerta.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            //self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alerta, animated: true, completion: nil)
        
    }
}
//    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PostCell
//    imageFiles[indexPath.row].getDataInBackgroundWithBlock { (data, error) in
//    if let imgDown = UIImage(data: data!){
//    cell.postedImage.image = imgDown
//    
//    }
//    }
//    
//    //cell.postedImage.image = UIImage(named: "camera (2).png")
//    cell.message.text = messages[indexPath.row]
//    cell.userName.text = userNames[indexPath.row]
//    // Configure the cell...
//    
//    return cell
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        
//       // return self.section [section ]
//        
//    }




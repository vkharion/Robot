//
//  Application.swift
//  Xplor
//
//  Created by abc on 21/5/22.
//

import Foundation

enum Errors: Error {
    case invalidArgumentsNumber
    case invalidCommand(String)
    case unrecognizedCommand(String)
}

class Application {
    
    enum Mode {
        case filename(String)
        case interactive
        case help
        case invalid(Error)
        case unknown
    }
    
    lazy var mode: Mode = {
        return Mode(arguments: Array(arguments.dropFirst()))
    }()
    
    let source = CommandSource()
    let arguments: [String]
    let console: Console
    let fileManager: TextFileInputProtocol
    var robot: Robot
    var shouldExit = false
    
    init(arguments: [String] = CommandLine.arguments, console: Console = Console(), fileManager: TextFileManager = TextFileManager(), robot: Robot = Robot()) {
        self.arguments = arguments
        self.console = console
        self.fileManager = fileManager
        self.robot = robot
        
        self.robot.reportStateBlock = { state in
            console.print("\(state)")
        }
        
        source.command.observe(on: self) { [unowned self] command in
            guard let command = command else { return }
            if self.robot.handleCommand(command) == nil {
                let error = Errors.invalidCommand("\(command)")
                self.console.printError(error)
            }
        }
        source.error.observe(on: self) { [unowned self] error in
            guard let error = error else { return }
            if case let Errors.unrecognizedCommand(command) = error {
                if command == "EXIT" {
                    shouldExit = true
                    return
                }
            }
            self.console.printError(error)
        }
    }
    
    func run() {
        switch mode {
        case .filename(let filename):
            source.readFile(filename, fileManager: fileManager)
        case .interactive:
            console.print("Enter commands one at each line. Type EXIT to finish.")
            // Read and execute commands from the standard input
            while !shouldExit && source.readLine(console) { }
        case .help:
            printUsage()
        case .invalid(let error):
            console.printError(error)
            // Exit the program with a non-zero code to indicate failure
            exit(1)
        case .unknown:
            console.print("Unrecognized arguments. Use -h for help")
            // Exit the program with a non-zero code to indicate failure
            exit(1)
        }
    }
    
    private func printUsage() {
        let executableName = (arguments.first as NSString?)?.lastPathComponent ?? ""
        let message = """
        Xplor Robot Simulator

        Usage: \(executableName) [arguments]

        -h          \t Show usage information
        -f filename \t Execute commands from the file

        Type \(executableName) without arguments to enter interactive mode.
        """
        console.print(message)
    }
}


extension Application.Mode {
    init(arguments: [String]) {
        if arguments.count == 0 {
            self = .interactive
        } else {
            switch arguments.first! {
            case "-f":
                if arguments.count == 2 {
                    self = .filename(arguments.last!)
                } else {
                    let error = Errors.invalidArgumentsNumber
                    self = .invalid(error)
                }
            case "-h":
                self = .help
            default:
                self = .unknown
            }
        }
    }
}


extension Errors: CustomStringConvertible {
    var description: String {
        switch self {
        case .invalidArgumentsNumber:
            return "Invalid number of arguments"
        case .invalidCommand(let command):
            return "Invalid command: \(command)"
        case .unrecognizedCommand(let command):
            return "Unrecognized command: \(command)"
        }
    }
}

% CLIENT connect to a server and read a message
%
% Usage - message = client(host, port, number_of_retries)
function [person, message,input_socket] = client(host, port,input_socket, person,number_of_retries)
%person stays the same unless a new person is parsed

    import java.net.Socket
    import java.io.*

    if (nargin < 5)
        number_of_retries = 3; % set to -1 for infinite
    end
    
    retry        = 0;
    %person='';
    message=[];

    if isempty(input_socket)
            while true

                retry = retry + 1;
                if ((number_of_retries > 0) && (retry > number_of_retries))
                    fprintf(1, 'Too many retries\n');
                    break;
                end

                try
                    fprintf(1, 'Try %d\n',retry);

                    % throws if unable to connect
                    input_socket = Socket(host, port);

                    break;

                catch
                    % pause before retrying
                    pause(.2);%1
                end
            end
    end
    if ~isempty(input_socket)
        try
            message=receiveMessage(input_socket);
            if ~isempty(message) && isletter(message(1,1))
                person=message(1,1:20);
                message=message(1,21:end);
                person=strtrim(person);
            end
        catch err
            input_socket.close;
            rethrow(err)
        end
    end
    person

end
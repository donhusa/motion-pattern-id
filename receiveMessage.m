function message=receiveMessage(input_socket)

    import java.net.Socket
    import java.io.*

    fprintf('trying\n');
    
    % get a buffered data input stream from the socket
    input_stream   = input_socket.getInputStream;
    d_input_stream = DataInputStream(input_stream);

    fprintf(1, 'Connected to server\n');

    % read data from the socket - wait a short time first
    pause(0.1);%.5
    bytes_available = input_stream.available;
    fprintf(1, 'Reading %d bytes\n', bytes_available);

    message = zeros(1, bytes_available, 'uint8');
    for i = 1:bytes_available
        message(i) = d_input_stream.readByte;
    end

    message = char(message);
    
end
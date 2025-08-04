"""
@author:    Ge Li, ge.li@kit.edu
@brief:     Defines training process of an image classifier
@detail:    Modified and inspired by the official PyTorch Tutorial:
            https://pytorch.org/tutorials/beginner/blitz/cifar10_tutorial.html
"""

# DO NOT MODIFY THIS BLOCK
# DO NOT MODIFY THIS BLOCK
# DO NOT MODIFY THIS BLOCK


# Import Python libs
from collections import OrderedDict
import matplotlib.pyplot as plt
import torch
import torch.nn as nn
import torch.optim as optim
from tqdm import trange
from ex2.data_loader import get_data_loader

# Get data loaders
# data loader is an object used as as an iterator, which can be use in the
# for... in loop, such as:
#
#             for data in dataloader:
#                 blablabla...

train_loader, valid_loader, test_loader = get_data_loader()


def fit(model, max_epochs, early_stop=True):
    """
    Train model, store the best model, and run a final test.
    :param model: NN model used in the image classification
    :param max_epochs: the iteration number for using all data in train_dataset
    :param early_stop: stop the training if the loss in valid_dataset
    keeps increases
    :return: None
    """

    # Use cross entropy as the loss function in classification
    loss_func = nn.CrossEntropyLoss()

    # Define an optimizer for gradient descent
    optimizer = optim.Adam(model.parameters(), lr=0.001)

    # Initialize a dict to store the best model during training
    best_model_dict = model.state_dict()

    # Define a iterator object to print progress bar
    epochs = trange(max_epochs, desc=model.__class__.__name__ + ' Training',
                    unit='Epoch', dynamic_ncols=True)

    # Record the training and validation loss
    train_loss_list = []
    valid_loss_list = []

    # Initialize a figure to show loss functions
    plt.figure()

    # Main loop. Each iteration will use all the data in training dataset,
    # called as epoch.
    for epoch in epochs:
        # Unfreeze the parameters in the NN model
        model.train()
        train_batch_num = 0
        train_loss = 0.0
        # each batch, a group of data in the dataset form a batch.
        for train_data in train_loader:
            # get the inputs; data is a list of [inputs, labels]
            inputs, labels = train_data
            # zero the parameter gradients. Every time after do gradient
            # back-propagation, the gradient will remain in the model,
            # we need to clean it before update again.
            optimizer.zero_grad()

            # compute outputs, here your "forward" function in the model will
            # be called by PyTorch automatically.
            outputs = model(inputs)

            # Compute loss, here the loss is averaged to the batch.
            loss = loss_func(outputs, labels)

            # loss back propagation
            loss.backward()

            # The parameters in the model get updated
            optimizer.step()

            # get some statistics
            train_loss += loss.item()
            train_batch_num += 1

        # save train loss of current epoch
        train_loss_list.append(train_loss / train_batch_num)

        # Before we evaluate the data, we need to frozen the parameters in
        # the model
        model.eval()

        # Use valid dataset to evaluate the training result. This can avoid
        # over-fitting
        valid_loss = 0.0
        valid_batch_num = 0

        for valid_data in valid_loader:
            # get the inputs; data is a list of [inputs, labels]
            inputs, labels = valid_data

            # Compute loss
            outputs = model(inputs)
            loss = loss_func(outputs, labels)

            # get statistics
            valid_loss += loss.item()
            valid_batch_num += 1

        # save validation loss of current epoch
        valid_loss_list.append(valid_loss / valid_batch_num)

        # Print some figures...
        plt.ion()
        plt.plot(range(1, epoch + 2), train_loss_list, color='b')
        plt.plot(range(1, epoch + 2), valid_loss_list, color='r')
        plt.legend(["Train loss", "valid loss"])
        plt.xlabel("Epochs")
        plt.ylabel("Cross-Entropy Loss")
        plt.title("Training and validation loss in " + model.__class__.__name__)
        plt.show()
        plt.pause(0.05)
        # plt.ioff()

        # export the training losses to the progress bar
        epochs.set_postfix(OrderedDict({"train_loss": train_loss_list[-1],
                                        "valid_loss": valid_loss_list[-1]}))

        # Record the best model
        if epoch > 0 and valid_loss_list[-1] == min(valid_loss_list):
            best_model_dict = model.state_dict()

        # Apply early stopping
        if early_stop and epoch > 5 and min(valid_loss_list) not in \
                valid_loss_list[-5:]:
            break

    print("Finished Training.")

    # Training is finished, now get our best model to test
    model.load_state_dict(best_model_dict)

    correct = 0
    total = 0
    with torch.no_grad():
        # We use test dataset for testing
        for data in test_loader:
            images, labels = data
            outputs = model(images)
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
    print('Accuracy of the network on the 10000 test images: %.2f %%' % (
            100 * correct / total))

// Tests the LinkedList implementation.
#include "gtest/gtest.h"

#include "cpptools/linkedlist.h"


class LinkedListTest : public ::testing::Test {
  protected:
    // Reference on setup/teardown vs constructors/destructors:
    // https://stackoverflow.com/a/13587712
    virtual void SetUp() {
    }

    virtual void TearDown() {
    }
};

TEST_F(LinkedListTest, DefaultConstructor) {
  cpptools::LinkedList<int> ll;
  EXPECT_EQ(ll.size(), 0);
}

TEST_F(LinkedListTest, LValueConstructor) {
  int i = 0;
  cpptools::LinkedList<int> ll{i};
  EXPECT_EQ(ll.size(), 1);
}

TEST_F(LinkedListTest, RValueConstructor) {
  cpptools::LinkedList<int> ll{0};
  EXPECT_EQ(ll.size(), 1);
}

TEST_F(LinkedListTest, CopyConstructor) {
  cpptools::LinkedList<int> ll1{0};
  ll1.push_front(1);
  cpptools::LinkedList<int> ll2 = ll1;
  EXPECT_EQ(ll1.size(), 2);
  EXPECT_EQ(ll2.size(), 2);
  EXPECT_EQ(ll2.pop_front(), 1);
  EXPECT_EQ(ll2.pop_front(), 0);
  EXPECT_EQ(ll2.size(), 0);
  EXPECT_EQ(ll1.size(), 2);
}

TEST_F(LinkedListTest, MoveConstructor) {
  cpptools::LinkedList<int> ll1{1};
  cpptools::LinkedList<int> ll2 = std::move(ll1);
  EXPECT_EQ(ll1.size(), 0);
  EXPECT_EQ(ll2.size(), 1);
  EXPECT_EQ(ll2.pop_front(), 1);
}

TEST_F(LinkedListTest, CopyAssignment) {

}

TEST_F(LinkedListTest, MoveAssignment) {

}

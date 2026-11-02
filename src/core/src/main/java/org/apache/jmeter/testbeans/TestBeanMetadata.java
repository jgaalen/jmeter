/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to you under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.apache.jmeter.testbeans;

import java.beans.IntrospectionException;
import java.beans.Introspector;

import org.apache.jmeter.testelement.TestElement;

/** Initializes BeanInfo and customizer classes before virtual samplers start. */
public final class TestBeanMetadata {
    private TestBeanMetadata() { }

    /** Loads metadata only; does not evaluate expressions or prepare bean values. */
    public static void prewarm(TestElement element) {
        if (element instanceof TestBean) {
            try {
                Introspector.getBeanInfo(element.getClass());
            } catch (IntrospectionException e) {
                throw new IllegalArgumentException("Could not initialize bean metadata for "
                        + element.getClass().getName(), e);
            }
        }
    }
}

﻿#Область ОбработчикиСобытийФормы

// Процедура - обработчик события ПриОткрытии.
//
&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Отказ = Истина;
	ПоказатьПредупреждение(, НСтр("ru='Обработка не предназначена для непосредственного использования.'"));

КонецПроцедуры

#КонецОбласти

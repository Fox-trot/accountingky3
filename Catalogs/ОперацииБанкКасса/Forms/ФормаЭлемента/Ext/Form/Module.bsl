﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Объект.ВидДокумента = "ППИ" Тогда
		Массив = Новый Массив();
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийППИ"));
		ОписаниеТипов = Новый ОписаниеТипов(Массив);	
	Иначе
		Массив = Новый Массив();
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийРКО"));
		ОписаниеТипов = Новый ОписаниеТипов(Массив);
	КонецЕсли;	
	
	Элементы.ВидОперации.ОграничениеТипа = ОписаниеТипов;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВидДокументаПриИзменении(Элемент)
	
	Объект.ВидОперации = Неопределено;
	
	Если Объект.ВидДокумента = "ППИ" Тогда
		Массив = Новый Массив();
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийППИ"));
		ОписаниеТипов = Новый ОписаниеТипов(Массив);	
	Иначе
		Массив = Новый Массив();
		Массив.Добавить(Тип("ПеречислениеСсылка.ВидыОперацийРКО"));
		ОписаниеТипов = Новый ОписаниеТипов(Массив);
	КонецЕсли;	
	
	Элементы.ВидОперации.ОграничениеТипа = ОписаниеТипов;
КонецПроцедуры

#КонецОбласти
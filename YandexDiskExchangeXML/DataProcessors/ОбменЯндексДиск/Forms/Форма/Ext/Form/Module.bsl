﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПутьКФормам = РеквизитФормыВЗначение("Объект").Метаданные().ПолноеИмя() + ".Форма";
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ПолучениеКодаАвторизации" Тогда
		Объект.КодАвторизации = Параметр;
		Активизировать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокФайловВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.СписокФайлов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	ИначеЕсли ТекущиеДанные.Тип = "file" Тогда
		Адрес = СкачатьФайлНаСервере(ТекущиеДанные.Путь);
		ПолучитьФайл(Адрес, ТекущиеДанные.Имя + ?(ТекущиеДанные.Тип = "dir", ".zip", ""), Истина);
	ИначеЕсли ТекущиеДанные.Тип = "dir" Тогда
		ТекущееРасположение = ТекущиеДанные.Путь + "/";
		СписокФайловНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПапкаПриложения(Команда)
	ТекущееРасположение = "app:/";
	СписокФайловНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокФайлов(Команда)
	СписокФайловНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ТекущееРасположениеПриИзменении(Элемент)
	СписокФайловНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьФайл(Команда)
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогВыбораФайла.МножественныйВыбор = Ложь;
	ОписаниеОповещение = Новый ОписаниеОповещения("ОбработкаВыбораФайла", ЭтаФорма);
	ДиалогВыбораФайла.Показать(ОписаниеОповещение);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьПапку(Команда)
	ИмяПапки = "";
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаВводаИмениПапки", ЭтаФорма);
	ПоказатьВводСтроки(ОписаниеОповещения, ИмяПапки, "Введите имя папки", 255);
КонецПроцедуры

&НаКлиенте
Процедура УдалитьПапкуИлиФайл(Команда)
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработкаРешенияОбУдалении", ЭтаФорма);
	ПоказатьВопрос(ОписаниеОповещения, "Вы уверены?", РежимДиалогаВопрос.ДаНет);
КонецПроцедуры

&НаКлиенте
Процедура КорневаяПапка(Команда)
	ТекущееРасположение = "disk:/";
	СписокФайловНаКлиенте();
КонецПроцедуры

&НаКлиенте
Процедура КодАвторизации(Команда)
	ПараметрыОткрытия = Новый Структура("IDПриложения", Объект.IDПриложения);
	ОткрытьФорму(ПутьКФормам + ".ФормаАвторизации", ПараметрыОткрытия, ЭтаФорма, УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПоднятьсяВверх(Команда)
	ПредпоследнийСлэш = СтрНайти(ТекущееРасположение, "/", НаправлениеПоиска.СКонца,, 2);
	Если ПредпоследнийСлэш Тогда
		ТекущееРасположение = Лев(ТекущееРасположение, ПредпоследнийСлэш);
		СписокФайловНаСервере();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Токен(Команда)
	ТокенНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Опубликовать(Команда)
	ТекущиеДанные = Элементы.СписокФайлов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ПубличнаяСсылка = ОпубликоватьНаСервере(ТекущиеДанные.Путь);
	ПоказатьВводСтроки(Новый ОписаниеОповещения("ОпубликоватьЗавершениеВводаСтроки", ЭтотОбъект, Новый Структура("ПубличнаяСсылка", ПубличнаяСсылка)), ПубличнаяСсылка);
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПубликацию(Команда)
	ТекущиеДанные = Элементы.СписокФайлов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОтменитьПубликациюНаСервере(ТекущиеДанные.Путь);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиАсинхронныхОповещений

&НаКлиенте
Процедура ОбработкаВыбораФайла(ИменаВыбранныхФайлов, ДополнительныеПараметры) Экспорт
	Если ИменаВыбранныхФайлов = Неопределено Тогда
		Возврат;
	КонецЕсли;
	КраткоеИмяФайла = Сред(ИменаВыбранныхФайлов[0], СтрНайти(ИменаВыбранныхФайлов[0], "\", НаправлениеПоиска.СКонца) + 1);
	АдресХранилища = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИменаВыбранныхФайлов[0]));
	ВыбранныйФайл = Новый Структура("Путь, АдресХранилища", ТекущееРасположение + КраткоеИмяФайла, АдресХранилища);
	ЗагрузитьФайлНаСервере(ВыбранныйФайл);
	ПодключитьОбработчикОжидания("СписокФайловНаКлиенте", 1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВводаИмениПапки(ИмяПапки, ДополнительныеПараметры) Экспорт
	Если ИмяПапки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СоздатьПапкуНаСервере(ТекущееРасположение + ИмяПапки);
	ПодключитьОбработчикОжидания("СписокФайловНаКлиенте", 1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаРешенияОбУдалении(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Если РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	ТекущиеДанные = Элементы.СписокФайлов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	УдалитьПапкуИлиФайлНаСервере(ТекущееРасположение + ТекущиеДанные.Имя);
	ПодключитьОбработчикОжидания("СписокФайловНаКлиенте", 1, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОпубликоватьЗавершениеВводаСтроки(Строка, ДополнительныеПараметры) Экспорт
КонецПроцедуры
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СписокФайловНаКлиенте()
	СписокФайловНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьФайлНаСервере(ВыбранныйФайл)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ЗагрузитьФайл(ВыбранныйФайл.Путь, ВыбранныйФайл.АдресХранилища);
КонецПроцедуры

&НаСервере
Процедура СоздатьПапкуНаСервере(Знач Путь)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.СоздатьПапку(Путь);
КонецПроцедуры

&НаСервере
Процедура УдалитьПапкуИлиФайлНаСервере(Путь)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.УдалитьПапкуИлиФайл(Путь);
КонецПроцедуры

&НаСервере
Функция СкачатьФайлНаСервере(Путь)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.СкачатьФайл(Путь);
КонецФункции

&НаСервере
Процедура СписокФайловНаСервере()
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.СписокФайлов(ТекущееРасположение);
	ЗначениеВРеквизитФормы(ОбъектОбработки, "Объект");
КонецПроцедуры

&НаСервере
Процедура ТокенНаСервере()
	ОбъектОбработки = РеквизитФормыВЗначение("Объект");
	ОбъектОбработки.Токен();
	ЗначениеВРеквизитФормы(ОбъектОбработки, "Объект");
КонецПроцедуры

&НаСервере
Функция ОпубликоватьНаСервере(Путь)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	Возврат ОбработкаОбъект.ОпубликоватьПапкуИлиФайл(Путь);
КонецФункции

&НаСервере
Процедура ОтменитьПубликациюНаСервере(Путь)
	ОбработкаОбъект = РеквизитФормыВЗначение("Объект");
	ОбработкаОбъект.ОтменитьПубликациюФайлаИлиПапки(Путь);
КонецПроцедуры

#КонецОбласти
